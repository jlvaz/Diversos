sga_max_size = 6032M = 6G
sga_target   = 6Gb
pga_aggregate_target = 2007M

-- Configurando ASMM + PGA automática (substituir xG pelo tamanho  desejado)
alter system set sga_target = 24G scope=spfile; --  tam. desejado da SGA
alter system set sga_max_size = 24G scope=spfile;   -- tam. máximo da SGA
alter system set pga_aggregate_target = xG scope=spfile; -- tam.  desejado da PGA

alter system set sga_target = 6G scope=spfile; --  tam. desejado da SGA
alter system set sga_max_size = 6G scope=spfile;   -- tam. máximo da SGA


create pfile from spfile





No 11G, a Oracle criou um novo tipo de gerenciamento automático, que permite agora, configurar o tamanho da SGA e PGA através de um único parâmetro (MEMORY_TARGET), e chamou isso de AMM (Automatic Memory Management). Segue abaixo um script que deve ser utilizado como exemplo para configurar AMM:

-- Configurando AMM (substituir xG pelo  tamanho desejado)
alter system set memory_target = xG scope=spfile; --  tam. desejado 
alter system set memory_max_target = xG scope=spfile;   -- tam. máximo