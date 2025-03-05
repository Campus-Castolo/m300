# m300
Integrate cross-platform services into a network

<h6>please pay attention to the repository navigation this is very important</h6>

## What is this repo about
This repo is the project repo for m300 module about integrating cross-platform services to deliever one product.
The project is the following: using github action which will be triggered on code push on the branch `main` the image will be automatically be build on the ECR and in junction with Terraform immedietly deployed on the AWS cloud with the right configurations. The image which will be used is WordPress, this WordPress instance will be connected with Amazon RDS which will be replicated into another Amazon RDS, these RDS DBs will also be Snapshotted into a Block Storage and all will be monitored and logged by Amazon CloudWatch.

---

# Repository Navigation

## [To Wiki](https://github.com/Campus-Castolo/m300/wiki/Home)

## [To Weekly Log](https://github.com/Campus-Castolo/m300/wiki/weekly-logs)

## [To competency matrix](https://gitlab.com/ch-tbz-it/Stud/m300/m300-bivo2021/-/blob/main/Kompetenzmatrix.md)
