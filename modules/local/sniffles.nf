process SNIFFLES {
    tag "$meta.id"
    label 'process_high'

    conda (params.enable_conda ? "bioconda::sniffles=1.0.12" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/sniffles:1.0.12--h8b12597_1' :
        'quay.io/biocontainers/sniffles:1.0.12--h8b12597_1' }"

    input:
    tuple val(meta), path(sizes), val(is_transcripts), path(bam), path(bai)


    output:
    tuple val(meta), path("*_sniffles.vcf") , emit: sv_calls // vcf files
    path "versions.yml"                     , emit: versions


    script:
    """
    sniffles \
        -m  $bam \
        -v ${meta.id}_sniffles.vcf \
        -t $task.cpus

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        sniffles: \$(sniffles --help 2>&1 | grep Version |sed 's/^.*Version: //')
    END_VERSIONS
    """
}

