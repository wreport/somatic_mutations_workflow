workflow mutect2_workflow {
    File bam
    File bai
    File reference
    File referencefai
    File referencedict
    String results_folder

    call mutect2_task as mutect2_call {
        input:
            bam = bam,
            reference = reference
    }
    call copy_task as copy_call {
        input:
            files = mutect2_call.out,
            destination = results_folder
    }
}

task mutect2_task {
    File bam
    File reference

    command {
        java -jar /usr/GenomeAnalysisTK.jar \
        -T PrintReads \
        -R ${reference} \
        -I ${bam} \
        -BQSR recalibration_report.grp \
        --artifact_detection_mode \
        -o output.bam
    }

    runtime {
        docker: "broadinstitute/gatk3:3.8-0@sha256:523f2c94c692c396157e50a2600ba5dfc392c8281f760445412d3daf031e846a"
      }

    output {
        File out = "output.bam"
      }

}

task copy_task {
    Array[File] files
    String destination

    command {
        mkdir -p ${destination}
        cp -L -R -u ${sep=' ' files} ${destination}
    }

    output {
        Array[File] out = files
    }
}
