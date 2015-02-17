for b in $(echo *); do
    if [ -d "$b" ]; then
        cd $b
        ./build.sh clean
        cd ..
    fi
done
