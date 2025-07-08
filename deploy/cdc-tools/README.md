# Oracle to Kafka CDC Replication

This project sets up Change Data Capture (CDC) replication from Oracle XE to Kafka using Debezium.

## Prerequisites

- Docker
- Docker Compose
- PowerShell (for Windows) or Bash (for Linux/Mac)

## Architecture

The solution consists of the following components:
- Oracle XE 21c - Source database
- Apache Kafka - Message broker
- Debezium - CDC connector
- Kafka UI - Web interface for monitoring

## Setup Instructions

1. Clone the repository:
```bash
git clone <repository-url>
cd <repository-directory>
```

2. Start the services:
```bash
docker-compose up -d
```

3. Wait for Oracle to initialize (3-5 minutes). You can check the status with:
```bash
docker-compose ps
```

4. Verify Oracle connection:
```bash
docker exec -it oracle-xe sqlplus test_user/test_password@//localhost:1521/XEPDB1
```

5. Create the Debezium connector:
```powershell
# For Windows PowerShell
curl.exe -X POST -H "Content-Type: application/json" --data @oracle-connector.json http://localhost:8083/connectors

# For Linux/Mac
curl -X POST -H "Content-Type: application/json" --data @oracle-connector.json http://localhost:8083/connectors
```

## Verification Steps

After connecting to Oracle, you can verify the setup using the following SQL queries:

1. Check the created table:
```sql
-- View table structure
DESC test_table;

-- View table data
SELECT * FROM test_table;

-- Check table privileges
SELECT * FROM user_tab_privs WHERE table_name = 'TEST_TABLE';
```

2. Check user privileges:
```sql
-- View system privileges
SELECT * FROM session_privs;

-- View object privileges
SELECT * FROM user_tab_privs;

-- View all granted privileges
SELECT * FROM dba_sys_privs WHERE grantee = 'TEST_USER';
```

3. Check user roles:
```sql
-- View assigned roles
SELECT * FROM session_roles;

-- View role privileges
SELECT * FROM role_sys_privs WHERE role IN (
    SELECT granted_role FROM dba_role_privs WHERE grantee = 'TEST_USER'
);

-- View detailed role information
SELECT 
    rp.granted_role,
    rp.admin_option,
    rp.default_role
FROM dba_role_privs rp
WHERE rp.grantee = 'TEST_USER';
```

## Testing the Setup

1. Execute test data changes:
```bash
docker exec -i oracle-xe sqlplus test_user/test_password@//localhost:1521/XEPDB1 @test-replication.sql
```

2. Monitor the changes in Kafka UI:
- Open http://localhost:8080 in your browser
- Navigate to Topics
- Look for the topic `oracle.TEST_USER.TEST_TABLE`

## Configuration Files

### docker-compose.yml
Contains the configuration for all services:
- Oracle XE
- Zookeeper
- Kafka
- Kafka Connect (Debezium)
- Kafka UI

### oracle-connector.json
Debezium connector configuration for Oracle CDC.

### oracle/init/01-init.sql
Oracle initialization script that:
- Creates test_user
- Grants necessary privileges
- Creates test table
- Inserts sample data

### test-replication.sql
Test script for data changes:
- Inserts new records
- Updates existing records
- Deletes records

## Monitoring

1. Check Oracle logs:
```bash
docker-compose logs -f oracle-xe
```

2. Check Debezium logs:
```bash
docker-compose logs -f kafka-connect
```

3. Access Kafka UI:
- URL: http://localhost:8080
- Features:
  - Topic browsing
  - Message inspection
  - Consumer group monitoring
  - Broker status

## Troubleshooting

### Common Issues

1. Oracle Connection Issues:
```bash
# Check Oracle status
docker-compose ps oracle-xe

# Check Oracle logs
docker-compose logs oracle-xe
```

2. Debezium Connector Issues:
```bash
# Check connector status
curl http://localhost:8083/connectors/oracle-connector/status

# Check connector logs
docker-compose logs kafka-connect
```

3. Kafka Issues:
```bash
# Check Kafka status
docker-compose ps kafka

# Check Kafka logs
docker-compose logs kafka
```

### Reset Environment

To start fresh:
```bash
# Stop all services and remove volumes
docker-compose down -v

# Start services again
docker-compose up -d
```

## Ports

- Oracle: 1521
- Kafka: 9092
- Kafka Connect: 8083
- Kafka UI: 8080
- Zookeeper: 2181

## Security Notes

- Default credentials are used for demonstration purposes
- In production, use secure passwords and proper security measures
- Consider using secrets management for sensitive data

## Maintenance

### Backup
```bash
# Backup Oracle data
docker exec oracle-xe expdp system/oracle@//localhost:1521/XEPDB1 directory=DATA_PUMP_DIR dumpfile=backup.dmp
```

### Cleanup
```bash
# Remove all containers and volumes
docker-compose down -v

# Remove unused volumes
docker volume prune
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details. 