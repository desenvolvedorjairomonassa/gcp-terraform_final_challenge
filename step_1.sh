

## Task 1. Create the configuration files
## no cloud shell
export REGION=$1
export ZONE=$2
export PROJETO_ID=$(gcloud config list --format 'value(core.project)')

touch main.tf variables.tf outputs.tf
chmod 770 main.tf variables.tf outputs.tf
mkdir -m 770 -p modules/instances 
mkdir -m 770 -p modules/storage 
cd modules/instances 
touch instances.tf variables.tf outputs.tf
chmod 770 instances.tf variables.tf outputs.tf
cd ../storage
touch storage.tf variables.tf outputs.tf
chmod 770 storage.tf variables.tf outputs.tf
cd ../..

echo "variable \"region\" {     "    >>  variables.tf
echo " default = \"${REGION}\" "  >>  variables.tf
echo "} "   >>  variables.tf
echo "variable \"zone\" { "   >>  variables.tf
echo " default = \"${ZONE}\" "  >>  variables.tf
echo "} "  >>  variables.tf
echo "variable \"project_id\" {   "  >>  variables.tf
echo " default = \"${PROJETO_ID}\"  " >>  variables.tf
echo "} " >>  variables.tf

cp variables.tf modules/instances/variables.tf
cp variables.tf modules/storage/variables.tf

echo " terraform {              " >> main.tf
echo "   required_providers {   " >> main.tf
echo "     google = { " >> main.tf
echo "       source = \"hashicorp/google\" " >> main.tf
echo "       version = \"4.53.0\" " >> main.tf
echo "     } " >> main.tf
echo "   } " >> main.tf
echo " } " >> main.tf
echo " provider \"google\" { " >> main.tf
echo "   project     = var.project_id " >> main.tf
echo "   region      = var.region " >> main.tf
echo "   zone        = var.zone " >> main.tf
echo " } " >> main.tf
echo " module \"instances\" { " >> main.tf
echo "   source     = \"./modules/instances\" " >> main.tf
echo " } " >> main.tf


terraform init 

## Task 2. Import infrastructure
#create instances.tf in root directory 
echo "resource \"google_compute_instance\" \"tf-instance-1\" {" >> instances.tf
echo "  name         = \"tf-instance-1\"" >> instances.tf
echo "  machine_type = \"n1-standard-1\"" >> instances.tf
echo "  zone         = var.zone" >> instances.tf
echo "" >> instances.tf
echo "  boot_disk {" >> instances.tf
echo "    initialize_params {" >> instances.tf
echo "      image = \"debian-cloud/debian-10\"" >> instances.tf
echo "    }" >> instances.tf
echo "  }" >> instances.tf
echo "" >> instances.tf
echo "  network_interface {" >> instances.tf
echo " network = \"default\"" >> instances.tf
echo "  }" >> instances.tf
echo "  metadata_startup_script = <<-EOT" >> instances.tf
echo "        #!/bin/bash" >> instances.tf
echo "    EOT" >> instances.tf
echo "  allow_stopping_for_update = true" >> instances.tf
echo "}" >> instances.tf
echo "" >> instances.tf
echo "resource \"google_compute_instance\" \"tf-instance-2\" {" >> instances.tf
echo "  name         = \"tf-instance-2\"" >> instances.tf
echo "  machine_type = \"n1-standard-1\"" >> instances.tf
echo "  zone         = var.zone" >> instances.tf
echo "" >> instances.tf
echo "  boot_disk {" >> instances.tf
echo "    initialize_params {" >> instances.tf
echo "      image = \"debian-cloud/debian-10\"" >> instances.tf
echo "    }" >> instances.tf
echo "  }" >> instances.tf
echo "" >> instances.tf
echo "  network_interface {" >> instances.tf
echo "     network = \"default\"" >> instances.tf
echo "  }" >> instances.tf
echo "  metadata_startup_script = <<-EOT" >> instances.tf
echo "        #!/bin/bash" >> instances.tf
echo "    EOT" >> instances.tf
echo "  allow_stopping_for_update = true" >> instances.tf
echo "}" >> instances.tf
# terraform init 

#get name of instance 1 and 2 and then get instance id
gcloud compute instances list --format 'value(name)' | head -n 1 | export INSTANCE_1
gcloud compute instances list --format 'value(name)' | head -n 2 | export INSTANCE_2
export INSTANCE_ID_1=$(gcloud compute instances describe $INSTANCE_1 --format='get(id)' --zone=$ZONE)
export INSTANCE_ID_2=$(gcloud compute instances describe $INSTANCE_2 --format='get(id)' --zone=$ZONE)

terraform init 

terraform apply

