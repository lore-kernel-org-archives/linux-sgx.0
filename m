Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB148C4320E
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Aug 2021 02:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C95A6103A
	for <linux-sgx@archiver.kernel.org>; Thu, 26 Aug 2021 02:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236891AbhHZCUy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 25 Aug 2021 22:20:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:9700 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235677AbhHZCUx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 25 Aug 2021 22:20:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10087"; a="239843049"
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="239843049"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 19:20:05 -0700
X-IronPort-AV: E=Sophos;i="5.84,352,1620716400"; 
   d="scan'208";a="527572260"
Received: from tgandhi-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.59.96])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 19:20:02 -0700
Date:   Thu, 26 Aug 2021 14:19:59 +1200
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 2/2] x86/sgx: Add SGX_MemTotal to /proc/meminfo
Message-Id: <20210826141959.5f13ff3c9c560c23b58443b1@intel.com>
In-Reply-To: <20210825235234.153013-2-jarkko@kernel.org>
References: <20210825235234.153013-1-jarkko@kernel.org>
        <20210825235234.153013-2-jarkko@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 26 Aug 2021 02:52:33 +0300 Jarkko Sakkinen wrote:
> The amount of SGX memory on the system is determined by the BIOS and it
> varies wildly between systems.  It can be from dozens of MB's on desktops
> or VM's, up to many GB's on servers.  Just like for regular memory, it is
> sometimes useful to know the amount of usable SGX memory in the system.
> 
> Add SGX_MemTotal field to /proc/meminfo, which shows the total amount of
> usable SGX memory in the system.  E.g. with 32 MB reserved for SGX from
> BIOS, the printout would be:
> 
> SGX_MemTotal:      22528 kB
> 
> It is less than 32 MB because some of the space is reserved for Enclave
> Page Cache Metadata (EPCM), which contains state variables for all the
> pages in the Enclave Page Cache (EPC).  The latter contains the pages,
> which applications can use to create enclaves.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> 
> ---
> v2:
> * Move ifdef fix for sgx_set_attribute() to a separate patch.
> ---
>  Documentation/x86/sgx.rst      | 6 ++++++
>  arch/x86/include/asm/sgx.h     | 2 ++
>  arch/x86/kernel/cpu/sgx/main.c | 7 ++++++-
>  arch/x86/mm/pat/set_memory.c   | 5 +++++
>  4 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
> index dd0ac96ff9ef..68ee171e1d8f 100644
> --- a/Documentation/x86/sgx.rst
> +++ b/Documentation/x86/sgx.rst
> @@ -250,3 +250,9 @@ user wants to deploy SGX applications both on the host and in guests
>  on the same machine, the user should reserve enough EPC (by taking out
>  total virtual EPC size of all SGX VMs from the physical EPC size) for
>  host SGX applications so they can run with acceptable performance.
> +
> +Supplemental fields for /proc/meminfo
> +=====================================
> +
> +SGX_MemTotal
> +	The total usable SGX protected memory in kilobytes.
> diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> index 996e56590a10..d8e526b5487b 100644
> --- a/arch/x86/include/asm/sgx.h
> +++ b/arch/x86/include/asm/sgx.h
> @@ -367,6 +367,8 @@ struct sgx_sigstruct {
>  
>  #ifdef CONFIG_X86_SGX
>  
> +extern unsigned long sgx_nr_all_pages;
> +
>  int sgx_set_attribute(unsigned long *allowed_attributes,
>  		      unsigned int attribute_fd);
>  
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 63d3de02bbcc..1fe26a8e80dc 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -28,7 +28,10 @@ static DECLARE_WAIT_QUEUE_HEAD(ksgxd_waitq);
>  static LIST_HEAD(sgx_active_page_list);
>  static DEFINE_SPINLOCK(sgx_reclaimer_lock);
>  
> -/* The free page list lock protected variables prepend the lock. */
> +/* The number of usable EPC pages in the system. */
> +unsigned long sgx_nr_all_pages;
> +
> +/* The number of free EPC pages in all nodes. */
>  static unsigned long sgx_nr_free_pages;
>  
>  /* Nodes with one or more EPC sections. */
> @@ -656,6 +659,8 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
>  		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
>  	}
>  
> +	sgx_nr_all_pages += nr_pages;
> +

EPC sections can be freed again in sgx_init() after they are successfully
initialized, when any further initialization fails (i.e. when fails to create
ksgxd, or fails to register /dev/sgx_provision).  In which case, I think
sgx_nr_all_pages should also be cleared.  But current sgx_init() seems doesn't
reset it.  Do you need to fix that too?

>  	return true;
>  }
>  
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index ad8a5c586a35..82bb09c298de 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -29,6 +29,7 @@
>  #include <asm/proto.h>
>  #include <asm/memtype.h>
>  #include <asm/set_memory.h>
> +#include <asm/sgx.h>

How about only include <asm/sgx.h> when CONFIG_X86_SGX is on, then you don't
have to do #ifdef CONFIG_X86_SGX changes to sgx.h?

>  
>  #include "../mm_internal.h"
>  
> @@ -116,6 +117,10 @@ void arch_report_meminfo(struct seq_file *m)
>  	if (direct_gbpages)
>  		seq_printf(m, "DirectMap1G:    %8lu kB\n",
>  			direct_pages_count[PG_LEVEL_1G] << 20);
> +
> +#if defined(CONFIG_X86_SGX) || defined(CONFIG_X86_SGX_KVM)
> +	seq_printf(m, "SGX_MemTotal:   %8lu kB\n", sgx_nr_all_pages << 2);
> +#endif

CONFIG_X86_SGX_KVM depends on CONFIG_X86_SGX, so I don't think KVM part is
required.

Plus, even  CONFIG_X86_SGX is on, EPC can be empty, i.e. when SGX FLC is not
present and KVM SGX is off too, or when SGX itslef is not present at all. 

Do you need to add additional check, for instance, only print when
sgx_nr_all_pages is not 0?

>  }
>  #else
>  static inline void split_page_count(int level) { }
> -- 
> 2.25.1
> 
