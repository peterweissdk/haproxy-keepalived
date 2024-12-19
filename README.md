# 🔄 HAProxy with Keepalived Container

[![Static Badge](https://img.shields.io/badge/Docker-Container-white?style=flat&logo=docker&logoColor=white&logoSize=auto&labelColor=black)](https://docker.com/)
[![Static Badge](https://img.shields.io/badge/Alpine-V3.21-white?style=flat&logo=alpinelinux&logoColor=white&logoSize=auto&labelColor=black)](https://www.alpinelinux.org/)
[![Static Badge](https://img.shields.io/badge/HAProxy-V3.0.7-white?style=flat&logoColor=white&labelColor=black)](https://www.haproxy.org/)
[![Static Badge](https://img.shields.io/badge/KeepAliveD-V2.3.1-white?style=flat&logoColor=white&labelColor=black)](https://keepalived.org/)
[![Static Badge](https://img.shields.io/badge/GPL-V3-white?style=flat&logo=gnu&logoColor=white&logoSize=auto&labelColor=black)](https://www.gnu.org/licenses/gpl-3.0.en.html/)

A robust, selfhost-ready Docker container combining HAProxy load balancing with Keepalived for high availability. This solution provides automatic failover capabilities and efficient load distribution for your services.

## ✨ Features

- **High Availability**: Automatic failover using Keepalived VRRP
- **Load Balancing**: Advanced load balancing with HAProxy
- **Health Checks**: Automated service health monitoring
- **Easy Configuration**: Simple environment variable configuration
- **Alpine-based**: Lightweight and secure base image
- **Fixed Scale**: 2 load balacing/failover deployments, serving 2 backend servers
- **HAProxy stats**: Near real-time feed of the proxied services

## 🚀 Quick Start

```bash
# Pull the image
docker pull haproxy-keepalived

# Run with custom configuration
docker run -d \
  --name haproxy-keepalived \
  --cap-add=NET_ADMIN \
  --net=host \
  --env-file=.env \
  haproxy-keepalived
```

## 🔧 Configuration

### Environment Variables

#### System Configuration

| Variable | Description | Example |
|----------|-------------|---------|
| TZ | System Timezone | Europe/Berlin |

#### Keepalived Settings

| Variable | Description | Example |
|----------|-------------|---------|
| VRRP_INSTANCE | VRRP instance name | VI_1 |
| INTERFACE | Network interface | eth0 |
| STATE | Node state (MASTER/BACKUP) | MASTER |
| PRIORITY | Node priority (1-255) | 100 |
| ROUTER_ID | Unique router ID | 51 |
| VIRTUAL_IPS | Virtual IP address | 192.168.1.10/24 |
| UNICAST_SRC_IP | Source IP for unicast | 192.168.1.2 |
| UNICAST_PEERS | Peer IP address | 192.168.1.3 |

#### HAProxy Frontend Settings

| Variable | Description | Example |
|----------|-------------|---------|
| NAME_FRONTEND | Frontend name | ha-frontend |
| PORT_FRONTEND | Listen port | 80 |
| PROTOCOL_FRONTEND | Frontend protocol | tcp |
| OPTION_FRONTEND | Frontend options | tcplog |
| DEFAULT_BACKEND | Default backend name | ha-backend |

#### HAProxy Backend Settings

| Variable | Description | Example |
|----------|-------------|---------|
| NAME_BACKEND | Backend name | ha-backend |
| PROTOCOL_BACKEND | Backend protocol | tcp |
| OPTION_BACKEND | Backend options | tcp-check |
| BALANCE_BACKEND | Server scheduling | roundrubin |

#### Backend Servers

| Variable | Description | Example |
|----------|-------------|---------|
| NAME_SERVER1 | Backend name | backend-server1 |
| IP_SERVER1 | Server IP address | 192.168.1.4 |
| PORT_SERVER1 | Listen port | 81 |
| NAME_SERVER2 | Backend name | backend-server2 |
| IP_SERVER2 | Server IP address | 192.168.1.5 |
| PORT_SERVER2 | Listen port | 81 |

## 🏗️ Building from Source

```bash
git clone https://github.com/yourusername/haproxy-keepalived.git
cd haproxy-keepalived
docker build -t haproxy-keepalived \
  --build-arg buildDate=$(date +'%Y-%m-%d') \
  --build-arg version=CONTAINER-VERSION \
  --build-arg revision=$(git rev-parse --short HEAD) \
  .
```

## 📝 Directory Structure

```bash
.
├── conf/
│   ├── haproxy/
│   │   └── haproxy.cfg_tpl
│   ├── keepalived/
│   │   └── keepalived.conf_tpl
│   └── supervisor/
│       ├── haproxy.ini
│       └── keepalived.ini
├── .env
├── Dockerfile
├── docker-entrypoint.sh
├── supervisord.conf
├── healthcheck.sh
├── LICENSE
└── README.md
```

## 🔍 Health Check

The container includes built-in health checks for both HAProxy and Keepalived services. Monitor the status using:

```bash
docker inspect --format='{{json .State.ExitCode}}' <container_name>
```

View the Docker health check logs with the following command:

```bash
docker inspect --format='{{json .State.Health}}' <container_name>
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 🆘 Support

If you encounter any issues or need support, please file an issue on the GitHub repository.

## 📄 License

This project is licensed under the GNU GENERAL PUBLIC LICENSE v3.0 - see the [LICENSE](LICENSE) file for details.

