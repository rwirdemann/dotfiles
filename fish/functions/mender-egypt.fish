function mender-egypt --wraps=mender-cli --description 'mender-cli terminal to the Egypt device'
    mender-cli terminal a3784145-acbc-4e12-86b8-5987aa62cf6b --server https://eu.hosted.mender.io $argv
end
