# Demos & Beispiele der Azure Technical Governance Session

Die Praesentation mit zusaetzlichen, beschreibenden Folien zu Syntax. [20171107-ELATGovernance.pdf](20171107-ELATGovernance.pdf)

## Tags

Beispiel im JSON format in [01-Tags.json](01-Tags.json)

## ARM Templates

- [02-TemplateStorageDemo.json](02-TemplateStorageDemo.json): einfaches Beispielfuer einen Storage Account inklusive Tag Parametern

## ARM Policies

Policybeispiele im JSON format:

- [03-PolicyExample01Loc.json](03-PolicyExample01Loc.json): Einschraenken der erlaubten Regionen, inklusive eines Parameters fuer ein Region Array
- [03-PolicyExample02Tags.json](03-PolicyExample02Tags.json): costCenter Tag wird erzwungen, falls Tags gesetzt sind aber das costCenter  Tag nicht gesetzt ist
