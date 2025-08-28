# Terraformando o Proxmox!

![Terraform](https://img.shields.io/badge/Terraform-1.13.1-purple?style=for-the-badge&logo=terraform&logoColor=white")
![Proxmox](https://img.shields.io/badge/Proxmox_VE-8.0-orange?style=for-the-badge&logo=proxmox&logoColor=white")
![BPG Provider](https://img.shields.io/badge/Provider-BPG%2FProxmox-green?style=for-the-badge)

Projeto **Terraform** para provisionamento automatizado de **VMs no Proxmox VE** usando o **provider BPG**.

Ideal para **homelabs**, **ambientes de teste** ou **automação de VMs**.

---

## 📝 Descrição

- Cria e configura múltiplas VMs a partir de um **template base com Cloud-Init**.  
- Arquitetura modular: permite definir atributos como CPU, RAM, disco e IP individualmente.  
- Suporte a **SSH Key** para autenticação segura.

---

## 📂 Estrutura do Projeto

```
.
├── main.tf                     # Configuração do provider e orquestração dos módulos
├── variables.tf                # Variáveis globais
├── outputs.tf                  # Saídas do Terraform
├── terraform.tfvars            # Variáveis específicas do ambiente
└── modules/
    └── vm/
        ├── main.tf             # Criação da VM
        ├── variables.tf        # Variáveis do módulo
        └── outputs.tf          # Saídas do módulo
```

---

## ⚙️ Principais Arquivos

### `main.tf`

- Configura o **provider BPG/Proxmox** e SSH para o node.  
- Orquestra módulos usando `for_each` para criar várias VMs com atributos customizados (`vm_id`, `cpu_cores`, `cpu_type`, `memory_mb`, `disk_size`, `ipv4_address`).

### `modules/vm/main.tf`

- Cria a VM com `proxmox_virtual_environment_vm`.  
- Clona o template base (`full = true`) para independência da VM.  
- Configura CPU, memória, disco e rede.  
- Configura **Cloud-Init**: IP estático e usuário com chave SSH.

> **Nota:** O provider BPG recomenda usuário e senha para operações completas (clonagem de templates e Cloud-Init), pois tokens de API podem não ter todas permissões.

---

## 🛠 Requisitos

- Terraform `~> 1.10`  
- Provider BPG `~> 0.82.1`  
- Proxmox VE `~> 8.0`  
- Template base com **Cloud-Init**  
- Chave SSH para autenticação

---

## 🔑 Configuração de Variáveis

### Usando `terraform.tfvars`

```hcl
proxmox_endpoint = "https://192.168.1.100:8006/api2/json"
proxmox_user     = "root@pam"
proxmox_password = "SUA_SENHA"
node_name        = "SEU_NODE"
base_template_id = 100
node_address     = "192.168.1.100"
disk_datastore      = "vms2"
cloudinit_datastore = "vms2"
ssh_public_key      = "/home/ubuntu/.ssh/k8scluster/k8s.pub"

vms = {
  VM-1 = { vm_id = 111, cpu_cores = 2, cpu_type = "host", memory_mb = 2048, disk_size = 30, ipv4_address = "192.168.1.111/24" }
  Vm-2  = { vm_id = 222, cpu_cores = 1, cpu_type = "host", memory_mb = 1024, disk_size = 15, ipv4_address = "192.168.1.222/24" }
}
```

### Usando variáveis de ambiente (`export`)

```bash
export TF_VAR_proxmox_password="SUA_SENHA"
export TF_VAR_node_name="SEU_NODE"
export TF_VAR_base_template_id=ID_DO_TEMPLATE_BASE
export TF_VAR_node_address="IP_DO_NODE"
export TF_VAR_ssh_private_key="/caminho/para/sua/chave_privada"
```

> ✅ Observações:
> - Substitua os valores pelos do seu ambiente.  
> - Variáveis de ambiente têm prioridade sobre `terraform.tfvars`.  
> - Nunca versionar senhas ou chaves privadas.

---

### Variáveis Globais

| Nome               | Tipo   | Descrição                                  |
| ------------------ | ------ | ------------------------------------------ |
| `proxmox_endpoint` | string | API Endpoint Proxmox                        |
| `proxmox_user`     | string | Usuário Proxmox                             |
| `proxmox_password` | string | Senha do usuário (sensitive)               |
| `node_name`        | string | Nome do node                                |
| `base_template_id` | number | ID do template base com Cloud-Init         |
| `node_address`     | string | IP do node para SSH                          |
| `disk_datastore`   | string | Datastore para discos da VM                 |
| `cloudinit_datastore` | string | Datastore para imagens Cloud-Init       |
| `ssh_public_key`   | string | Caminho da chave pública SSH               |
| `ssh_private_key`  | string | Caminho da chave privada SSH               |
| `vms`              | map    | Mapa de VMs com atributos (`vm_id`, CPU, RAM, disco, IP) |

### Variáveis do Módulo `vm`

| Nome             | Tipo   | Descrição                          |
| ---------------- | ------ | ---------------------------------- |
| `name`           | string | Nome da VM                         |
| `node_name`      | string | Nome do node                        |
| `vm_id`          | number | ID da VM                            |
| `base_template_id` | number | ID do template base                |
| `cpu_cores`      | number | Número de cores                     |
| `cpu_type`       | string | Tipo de CPU                         |
| `memory_mb`      | number | RAM em MB                            |
| `disk_size`      | number | Disco em GB                          |
| `disk_datastore` | string | Datastore do disco                   |
| `network_bridge` | string | Bridge de rede                       |
| `cloudinit_datastore` | string | Datastore Cloud-Init             |
| `ipv4_address`   | string | IP estático                          |
| `username`       | string | Usuário Cloud-Init                   |
| `ssh_public_key` | string | Chave pública SSH                     |
| `ssh_private_key`| string | Chave privada SSH                     |

---

## 📤 Outputs

| Nome      | Descrição           |
| --------- | ------------------ |
| `vm_names` | Lista de nomes das VMs |
| `vm_ids`   | Lista de IDs das VMs  |

---

## 🚀 Como Usar

1. Preencher `terraform.tfvars` ou definir variáveis de ambiente.  
2. Inicializar Terraform: `terraform init`  
3. Gerar plano: `terraform plan`  
4. Aplicar mudanças: `terraform apply`  
5. Destruir VMs (se necessário): `terraform destroy`

---

## 💡 Boas Práticas

- Use **SSH Key** sempre.  
- Modularize o código para reaproveitamento.  
- Evite provisioners desnecessários; Cloud-Init é suficiente.  
- Proteja credenciais (não versionar `.tfvars` sensíveis).

---

## 🔗 Recursos

- [Terraform Provider BPG](https://github.com/bpg/terraform-provider-proxmox)  
- [Documentação Proxmox VE](https://pve.proxmox.com/wiki/Main_Page)  
- [Cloud-Init](https://cloud-init.io/)
