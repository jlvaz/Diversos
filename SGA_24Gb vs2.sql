No dbfeso1

Aumentar o ponto de montagem tmpfs, para o dobro do memory_target, neste caso minha memory target 
desejável é 24GB.

Neste caso seria Adicionar o dobro dos 24GB (48Gb) no tmpfs:

    mount -t tmpfs shmfs -o size=49152m /dev/shm/

Configurando o /etc/fstab para ficar permanente quando a máquina ligar.

    shmfs /dev/shm tmpfs size=49152m 0 0

ALTER SYSTEM SET MEMORY_MAX_TARGET=24G SCOPE=SPFILE;

-- Set the dynamic parameters. Assuming Oracle has full control.
ALTER SYSTEM SET MEMORY_TARGET=24G SCOPE=SPFILE;
ALTER SYSTEM SET PGA_AGGREGATE_TARGET=0 SCOPE=SPFILE;
ALTER SYSTEM SET SGA_TARGET=0 SCOPE=SPFILE;

select * from v$parameter where name like '%memory%'

select * from v$parameter where name like '%sga%'

CREATE PFILE FROM SPFILE
ALTER SYSTEM SET SGA_MAX_SIZE=24G SCOPE=SPFILE

create pfile from spfile





No 11G, a Oracle criou um novo tipo de gerenciamento automático, que permite agora, 
configurar o tamanho da SGA e PGA através de um único parâmetro (MEMORY_TARGET), e chamou isso de AMM (Automatic Memory Management). 
Segue abaixo um script que deve ser utilizado como exemplo para configurar AMM:

-- Configurando AMM (substituir xG pelo  tamanho desejado)
alter system set memory_target = xG scope=spfile; --  tam. desejado 
alter system set memory_max_target = xG scope=spfile;   -- tam. máximo