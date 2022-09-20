#!/bin/bash
while read var ip; do
        sed -i "s/$var/$ip/" install.sh
<<<<<<< HEAD
done << "servers"
=======
done < "servers"
>>>>>>> ebe310c785930efa822792c22a46bd578a6bfd69
