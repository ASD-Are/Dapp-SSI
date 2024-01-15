// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <0.8.18;

contract MyContract {
    string public contractName;
    address public immutable owner; // Made owner immutable

    constructor() {
        contractName = "My Decentralized Identity Management Contract";
        owner = msg.sender;
    }

    struct Entity {
        address ethAddr; // Adjusted for mixedCase naming
        string pubKey;
        string userName; // Adjusted for mixedCase naming
        mapping (string => Certificate) certificates;
        mapping (address => bool) trustedEntities;
    }

    struct Certificate {
        string certName;
        string signedMessage; // Adjusted for mixedCase naming
        string issueDate;
        string expiryDate;
        address issuer;
        address hostAddress;
    }

    mapping(address => Entity) private addressToEntity;
    
    // This mapping will track the number of entities an address trusts
    mapping(address => uint256) public numberOfEntitiesTrusted;
    address[] public entityList;

    // Reverse mapping for trusted entities
    mapping(address => address[]) public trustiesOf;

    modifier onlyEntity() {
        require(isEntity(msg.sender), "Caller is not an entity");
        _;
    }

    function isEntity(address ethAddr) public view returns (bool) {
        for (uint i = 0; i < entityList.length; i++) {
            if (entityList[i] == ethAddr) {
                return true;
            }
        }
        return false;
    }

    function addEntity(string memory pubKey, string memory userName) public returns (string memory) {
        address ethAddr = msg.sender;

        require(!isEntity(ethAddr), "Entity already exists in the system");

        Entity storage newEntity = addressToEntity[ethAddr];
        newEntity.pubKey = pubKey;
        newEntity.userName = userName;
        entityList.push(ethAddr);
        return "success";
    }

    function deleteEntity() public onlyEntity {
        delete addressToEntity[msg.sender];
        for (uint i = 0; i < entityList.length; i++) {
            if (entityList[i] == msg.sender) {
                entityList[i] = entityList[entityList.length - 1];
                entityList.pop();
                break;
            }
        }
    }
    function addTrustedEntity(address trustedEntity) public onlyEntity returns (string memory) {
        require(trustedEntity != address(0), "Invalid address");
        require(isEntity(trustedEntity), "Entity not found");
        require(msg.sender != trustedEntity, "Cannot add self as a trusted entity");

        Entity storage senderEntity = addressToEntity[msg.sender];
        if (senderEntity.trustedEntities[trustedEntity]) {
            return "Entity already added as trusted";
        }

        senderEntity.trustedEntities[trustedEntity] = true;
        // Increase the count of trusted entities for the sender
        numberOfEntitiesTrusted[msg.sender]++;
        
        trustiesOf[trustedEntity].push(msg.sender);  // This line stays unchanged as it tracks reverse mapping for entities that trust an address

        return "success";
    }


    function addCertificate(string memory certificateName, address TempHostAddress) public onlyEntity returns (string memory) {
        Entity storage recipientEntity = addressToEntity[msg.sender];
        require(bytes(recipientEntity.certificates[certificateName].certName).length == 0, "Certificate already exists");
        require(isEntity(TempHostAddress), "Entity doesn't exist in the system");
        require(hasTrustedEntities(msg.sender), "Entity does not have any trusted entities");
        //does the host name exists in the smart contract
        
        Certificate memory newCertificate = Certificate({
            certName: certificateName,
            signedMessage: "",  // Empty string for now
            issueDate: "",  // Empty string for now
            expiryDate: "",  // Empty string for now
            issuer: address(0),
            hostAddress: TempHostAddress
        });


        recipientEntity.certificates[certificateName] = newCertificate;

        return "success";
    }

    // This function checks if the given address has added any trusted entities
    function hasTrustedEntities(address entityAddr) private view returns (bool) {
        return numberOfEntitiesTrusted[entityAddr] > 0;
    }


    function signCertificate(
        string memory certificateName,
        string memory signedMessage,
        address entityAddr,
        string memory expiryDate
    ) public returns (string memory) {
        require(isEntity(entityAddr), "Entity not found");
        require(addressToEntity[entityAddr].trustedEntities[msg.sender], "Issuer is not a trusted entity of the recipient");
        require(bytes(addressToEntity[entityAddr].certificates[certificateName].certName).length > 0, "Certificate does not exist");
        require(addressToEntity[entityAddr].certificates[certificateName].hostAddress != entityAddr, "Entity cannot be the host of its own certificate");
        address hostAddress = addressToEntity[entityAddr].certificates[certificateName].hostAddress;
        require(addressToEntity[hostAddress].trustedEntities[msg.sender], "Issuer is not a trusted entity of the host");
        //does the signing entity exists in the trusted entities of the host name
        // You need to get the current time in string format from your dApp and pass it as an argument
        // To Be Added: is the trusted entity member of the host name
        string memory issueDate = "current_time_in_string_format"; 

        Certificate memory newCertificate = Certificate({
            certName: certificateName,
            signedMessage: signedMessage,
            //To Be Added: hostname:
            issueDate: issueDate,
            expiryDate: expiryDate,
            issuer: msg.sender,
            hostAddress: addressToEntity[entityAddr].certificates[certificateName].hostAddress
        });

        addressToEntity[entityAddr].certificates[certificateName] = newCertificate;

        return "Certificate signed and assigned successfully";
    }

    function removeCertificate(string memory certificateName) public onlyEntity {
        Entity storage entity = addressToEntity[msg.sender];
        require(bytes(entity.certificates[certificateName].certName).length != 0, "Certificate not found");
        delete entity.certificates[certificateName];
    }

    function getEntityDetails(address entityAddr, string memory certificateName) public view returns (string memory, address, string memory, string memory) {
        require(isEntity(entityAddr), "Entity not found");
        require(msg.sender == entityAddr, "Cannot retrieve another entity's certificate details");
        Entity storage entity = addressToEntity[entityAddr];
        Certificate memory cert = entity.certificates[certificateName];
        require(bytes(cert.certName).length != 0, "Certificate not found");

        return (cert.signedMessage, cert.issuer, cert.issueDate, cert.expiryDate);
    }
}
