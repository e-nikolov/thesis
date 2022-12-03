.PHONY: notion

notion:
	rm -rf notion/*
	notion-exporter https://www.notion.so/e-nikolov/Abstract-b929d53335044965ae8cd441f1f13e4e | tail -n +2 > notion/00-abstract.md
	notion-exporter https://www.notion.so/e-nikolov/Introduction-0b4232f7ee5143748f6fa54c5cf94daa > notion/01-introduction.md
	notion-exporter https://www.notion.so/e-nikolov/Evaluation-Setup-Design-c4dcba251ecc47069a9d56e7d08ecaa1 > notion/02-evaluation-setup.md
	notion-exporter https://www.notion.so/e-nikolov/Evaluation-Setup-Implementation-7143d3fa0d5e42578b28ffe362149d59 | sed s@ocaml@terraform@g > notion/03-evaluation-setup-implementation.md
	notion-exporter https://www.notion.so/e-nikolov/Planning-1318176db63c4079a136dd9ff89b5ed9 > notion/04-planning.md
	notion-exporter https://www.notion.so/e-nikolov/Conclusions-cafd82912c3642e0a3642e4927cd1175 > notion/05-conclusions.md
