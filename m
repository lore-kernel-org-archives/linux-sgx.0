Return-Path: <SRS0=VWPK=5I=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97FB3C3F2CD
	for <linux-sgx@archiver.kernel.org>; Mon, 23 Mar 2020 03:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72E1B2070A
	for <linux-sgx@archiver.kernel.org>; Mon, 23 Mar 2020 03:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgCWDwc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 22 Mar 2020 23:52:32 -0400
Received: from mga17.intel.com ([192.55.52.151]:57856 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726983AbgCWDwc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 22 Mar 2020 23:52:32 -0400
IronPort-SDR: V8AHbwQcfluVWQ4f9d5xIHgrVZ+cbgBLDNe3aLNP6l7LBL1WUSyYzn2fKKBhy2ro17FOTUJTQj
 GeN3FQTn3kgw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2020 20:52:31 -0700
IronPort-SDR: ammLMgusH0JD6JxrGFONlvUPN8hTYFwd82xmhQ949UfvL7J8+Xb9Wx8A7aIj3sfCYyskeY4jbm
 uEgzxbL4Uq/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,295,1580803200"; 
   d="scan'208";a="239289424"
Received: from nspindel-mobl.ger.corp.intel.com (HELO localhost) ([10.214.214.10])
  by fmsmga008.fm.intel.com with ESMTP; 22 Mar 2020 20:52:29 -0700
Date:   Mon, 23 Mar 2020 05:52:27 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 1/5] selftests/sgx: Add PHDRS to encl.lds
Message-ID: <20200323035227.GA4658@linux.intel.com>
References: <20200323034634.4157-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323034634.4157-1-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Mar 23, 2020 at 05:46:30AM +0200, Jarkko Sakkinen wrote:
> Improve encl.lds to create an ELF image that can be easily loaded without
> needing the conversion to a raw binary. This is achieved by adding PHDRS to
> encl.lds that describes the different segments.
> 
> With a simple Python program it is easy to see that the changes result in a
> sane memory layout [1]:
> 
> Flags Start              End
> rw-   0x0000000000200000 0x0000000000201000
> r-x   0x0000000000201000 0x0000000000202000
> rw-   0x0000000000202000 0x0000000000205000
> 
> These are the start and end positions in the enclave ELF image for
> different enclave memory areas. Since all the sections are marked as being
> allocated, an ELF enclave loader can be solely based on p_offset, p_memsz
> and p_flags fields of struct Elf64_Phdr.
> 
> [1]
> import sys
> from elftools.elf.elffile import ELFFile
> 
> PAGE_SIZE = 0x1000
> 
> if __name__ == '__main__':
>     flags2str = ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx']
> 
>     if len(sys.argv) != 2:
>         sys.exit(1)
> 
>     with open(sys.argv[1], 'rb') as file:
>         file = ELFFile(file)
> 
>         print('{:<5} {:<18} {:<18}'.format('Flags', 'Start', 'End'))
> 
>         for seg in file.iter_segments():
>             if seg['p_type'] != 'PT_LOAD':
>                 continue
> 
>             flags = flags2str[seg['p_flags']]
> 
>             start = seg['p_offset'] & ~(PAGE_SIZE - 1)
>             end = start +
> 	          (seg['p_filesz'] + PAGE_SIZE - 1) & ~(PAGE_SIZE - 1)
> 
>             print('{:<5} 0x{:0>16x} 0x{:0>16x}'.format(flags, start, end))
> 
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  tools/testing/selftests/sgx/encl.lds         | 14 ++++++++++----
>  tools/testing/selftests/sgx/encl_bootstrap.S |  2 +-
>  2 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/sgx/encl.lds b/tools/testing/selftests/sgx/encl.lds
> index 9a56d3064104..0fbbda7e665e 100644
> --- a/tools/testing/selftests/sgx/encl.lds
> +++ b/tools/testing/selftests/sgx/encl.lds
> @@ -1,25 +1,31 @@
>  OUTPUT_FORMAT(elf64-x86-64)
>  
> +PHDRS
> +{
> +	tcs PT_LOAD;
> +	text PT_LOAD;
> +	data PT_LOAD;
> +}
> +
>  SECTIONS
>  {
>  	. = 0;
>  	.tcs : {
>  		*(.tcs*)
> -	}
> +	} : tcs
>  
>  	. = ALIGN(4096);
>  	.text : {
>  		*(.text*)
>  		*(.rodata*)
> -	}
> +	} : text
>  
>  	. = ALIGN(4096);
>  	.data : {
>  		*(.data*)
> -	}
> +	} : data
>  
>  	/DISCARD/ : {
> -		*(.data*)
>  		*(.comment*)
>  		*(.note*)
>  		*(.debug*)
> diff --git a/tools/testing/selftests/sgx/encl_bootstrap.S b/tools/testing/selftests/sgx/encl_bootstrap.S
> index 3a1479f1cdcf..b9ea6130e422 100644
> --- a/tools/testing/selftests/sgx/encl_bootstrap.S
> +++ b/tools/testing/selftests/sgx/encl_bootstrap.S
> @@ -7,7 +7,7 @@
>  	.byte 0x0f, 0x01, 0xd7
>  	.endm
>  
> -	.section ".tcs", "a"
> +	.section ".tcs", "aw"
>  	.balign	4096
>  
>  	.fill	1, 8, 0			# STATE (set by CPU)
> -- 
> 2.25.1
> 

These changes have been squashed to my tree. Please provide patches
if something feels not right.

The changes were live coded on a Geminilake NUC that I brought home
last week and are tested quite extensively.

The place for improvement would be to call sgx_encl_build_segment()
based on segments in the program header table so that the permissions
would be assigned dynamically.

/Jarkko
