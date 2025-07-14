# CDC Tools - Oracle Database 23c Free Edition

Change Data Capture tools for Oracle Database 23c Free using Kafka and Debezium.

## 🆕 Updated to Oracle Database 23c Free

This setup now uses the latest `gvenzl/oracle-free` Docker image which provides:
- Oracle Database 23c Free Edition
- Better performance and security
- Regular updates and patches
- Improved CDC capabilities
- No more outdated image warnings!

## Components

- **Oracle Database 23c Free** - Latest Oracle database
- **Apache Kafka** - Event streaming platform
- **Kafka Connect with Debezium** - CDC connector
- **Kafka UI** - Web interface for monitoring
- **Zookeeper** - Kafka coordination service

## Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│ Oracle Free 23c │───▶│ Debezium Connect │───▶│ Apache Kafka    │
│ (CDC Source)    │    │ (Change Capture) │    │ (Event Stream)  │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                │                        │
                                ▼                        ▼
                       ┌──────────────────┐    ┌─────────────────┐
                       │ Kafka UI         │    │ Your Apps       │
                       │ (Monitoring)     │    │ (Consumers)     │
                       └──────────────────┘    └─────────────────┘
```

## Database Structure

### 📁 DDL (Schema) - `/oracle/init/`
- `00-init-schema.sql` - Creates MOBILE schema and CDC setup
- `CLIENTS.sql`, `MODULES.sql`, etc. - Table definitions only
- `99-run-all-ddl.sql` - Executes all DDL scripts

### 📁 DML (Data) - `/oracle/data/`  
- `*_data.sql` - Initial data for tables (separated from structure)
- `99-load-all-data.sql` - Loads all data

## Quick Start

### 1. Start All Services
```bash
docker-compose up -d
```

### 2. Monitor Oracle Startup
```bash
docker logs oracle-free-local -f
```
Wait for: `"Oracle Database is ready for CDC!"`

### 3. Verify Database Setup
```bash
# Connect to Oracle
docker exec -it oracle-free-local sqlplus MOBILE/mobile123@//localhost:1521/FREEPDB1

# Check created tables
SQL> SELECT table_name FROM user_tables ORDER BY table_name;

# Verify data is loaded
SQL> SELECT COUNT(*) FROM MODULES;
SQL> SELECT COUNT(*) FROM USERS;
```

### 4. Access Kafka UI
- **URL:** http://localhost
- Monitor topics and connectors

## Database Connections

### MOBILE Schema (Main)
- **Host:** localhost
- **Port:** 1522
- **Service:** FREEPDB1
- **Schema:** MOBILE
- **User:** MOBILE
- **Password:** mobile123

### System Admin
- **User:** system
- **Password:** oracle
- **Service:** FREEPDB1

## CDC Configuration

### Register Oracle Connector
```bash
curl -X POST \
  http://localhost:8083/connectors \
  -H 'Content-Type: application/json' \
  -d @oracle-connector.json
```

### Monitor CDC Status
```bash
# Check connector status
curl http://localhost:8083/connectors/oracle-free-connector/status

# List all connectors
curl http://localhost:8083/connectors

# View Kafka topics
docker exec kafka-local kafka-topics --list --bootstrap-server localhost:9092
```

## Tables Monitored for CDC

The following tables are configured for Change Data Capture:

| Table | Description | Records |
|-------|-------------|---------|
| `MOBILE.CLIENTS` | Client information | 3 |
| `MOBILE.USERS` | User accounts | 5 |
| `MOBILE.MODULES` | Application modules | 17 |
| `MOBILE.MODULES_ACT` | Module actions | 38 |
| `MOBILE.ROLES` | User roles | 7 |
| `MOBILE.ROLES_ACT` | Role actions | 152 |
| `MOBILE.UC` | User-client relationships | 5 |

## Testing CDC

### 1. Make Database Changes
```sql
-- Connect to MOBILE schema
CONNECT MOBILE/mobile123@//localhost:1521/FREEPDB1;

-- Insert new client
INSERT INTO CLIENTS (ID, BRANCH, CLIENT, CREATED, STATE, TARIF, ABS) 
VALUES (9999, '00999', '99999999', SYSDATE, 1, null, 1);

-- Update user
UPDATE USERS SET NAME = 'Updated User Name' WHERE ID = 95577;

-- Delete a module action
DELETE FROM MODULES_ACT WHERE MODULE_ID = 208 AND ACTION_ID = 1;

COMMIT;
```

### 2. Monitor Changes in Kafka
- Open Kafka UI: http://localhost
- Check topics: `oracle-free.MOBILE.CLIENTS`, `oracle-free.MOBILE.USERS`, etc.
- View change events in real-time

## File Structure

```
deploy/cdc-tools/
├── docker-compose.yml               # Updated for Oracle Free
├── oracle-connector.json            # Updated connector config
├── README.md                        # This file
├── oracle/
│   ├── init/                        # Empty (not used)
│   └── data/                        # All scripts (executed in alphabetical order)
│       ├── 00-create-schema-and-tables.sql  # Creates MOBILE schema and all tables
│       ├── CLIENTS_data.sql         # Client data (3 records)
│       ├── MODULES_data.sql         # Module data (17 records)
│       ├── MODULES_ACT_data.sql     # Module actions (38 records)
│       ├── ROLES_data.sql           # Role definitions (7 records)
│       ├── ROLES_ACT_data.sql       # Role permissions (152 records)
│       ├── UC_data.sql              # User-client relationships (5 records)
│       ├── USERS_data.sql           # User accounts (5+ records)
│       └── 99-load-all-data.sql     # Data loading orchestrator
└── kafka-connect/
    └── oracle-connector.json
```

### Key Architecture Changes

- **Single Schema File:** All DDL consolidated in `00-create-schema-and-tables.sql`
- **Execution Order:** Docker executes scripts alphabetically, DDL first (00-), then data
- **Enhanced Column Sizes:** Increased VARCHAR2 sizes to handle longer text data
- **Automatic Setup:** No manual intervention needed, everything runs automatically

## Port Mappings

| Service | Internal Port | External Port | Purpose |
|---------|---------------|---------------|---------|
| Oracle Free | 1521 | 1522 | Database connection |
| Kafka | 29092 | 9092 | Kafka broker |
| Kafka Connect | 8083 | 8083 | REST API |
| Kafka UI | 8080 | 80 | Web interface |
| Zookeeper | 2181 | 2181 | Coordination |

## Troubleshooting

### Oracle Issues
```bash
# Check Oracle container status
docker ps | grep oracle-free

# View Oracle logs
docker logs oracle-free-local -f

# Connect to check database
docker exec -it oracle-free-local sqlplus system/oracle@//localhost:1521/FREEPDB1
```

### Kafka Connect Issues
```bash
# Check connector status
curl http://localhost:8083/connectors/oracle-free-connector/status

# View connector logs
docker logs kafka-connect-local -f

# Restart connector
curl -X POST http://localhost:8083/connectors/oracle-free-connector/restart
```

### Complete Reset
```bash
# Stop everything and remove volumes
docker-compose down -v

# Remove Oracle data (if needed)
docker volume rm cdc-tools_oracle-data-local cdc-tools_oracle-archive-local

# Start fresh
docker-compose up -d
```

## Performance Notes

- **Oracle Free Limits:** 2 CPUs, 2GB RAM, 12GB data
- **Archive Logging:** Enabled for CDC
- **Supplemental Logging:** Configured for all tables
- **LogMiner Strategy:** Online catalog for better performance
- **Connection Pooling:** Recommended for production use

## What's New in Oracle 23c Free

✅ **Latest Oracle Database features**  
✅ **Improved JSON support**  
✅ **Better performance**  
✅ **Enhanced security**  
✅ **No more deprecation warnings**  
✅ **Regular security updates**  

## Migration from Oracle XE

The migration includes:
- **Updated Docker image:** `gvenzl/oracle-free:latest`
- **Service name:** `FREEPDB1` (was `XEPDB1`)
- **Container name:** `oracle-free-local` (was `oracle-xe-local`)
- **Database name:** `FREE` (was `XE`)
- **Enhanced CDC configuration**
- **Separated DDL/DML scripts**

Old connections using `XEPDB1` need to be updated to use `FREEPDB1`. 