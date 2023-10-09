#!/bin/bash

#charger le nom
cat "./bin/name.txt"

#installer les dépendances si nécessaire
help=""
quality_control=""
help_specified=false
quality_control_specified=false

#traiter les arguments
for arg in "$@"; do
  if [[ "$arg" == "--help" ]]; then
    help_specified=true
  elif [[ "$help_specified" == true ]]; then
    help="$arg"
  elif [[ "$arg" == "--quality_control" ]]; then
      quality_control_specified=true
  elif [[ "$quality_control_specified" == true ]]; then
    quality_control="$arg"
  fi
done

if [ "$help_specified" == true ]; then
  cat "./bin/help.txt"
  exit 0
fi

#check si les dépendences sont bien installées
dependencies_file="./bin/dependencies_list.txt"
while IFS= read -r dep; do
    if [ "$dep" = "end" ]; then
        break
    fi
    if conda list -n analyzer | grep -q "$dep"; then
        echo "$dep is well installed."
    else
        echo "$dep is not installed."
    fi
done < "$dependencies_file"
echo -e "All the dependencies have been checked.\n"

#début des analyses
echo -e "Beginning of analysis."
#télécharger ou importer les données
bash "./modules/download_data.sh" "$@"
#trimmer les données
bash "./modules/clean_fastq.sh"
#contrôle qualité des fastq
if [ "$quality_control_specified" == true ]; then
  bash "./modules/quality_control.sh"
fi
#alignement
bash "./modules/mapping.sh"
#variant callinf
bash "./modules/variant_calling.sh"

echo -e "\n ---------------"
echo "| Analysis done |"
echo " ---------------"