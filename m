Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9800AC433F5
	for <linux-sgx@archiver.kernel.org>; Thu, 12 May 2022 03:27:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245698AbiELD1t (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 11 May 2022 23:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245499AbiELD1r (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 11 May 2022 23:27:47 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BF34D60F
        for <linux-sgx@vger.kernel.org>; Wed, 11 May 2022 20:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652326066; x=1683862066;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kryuM5gSNlq/AwsF+P+sPADujxzhtzVAF+VanU7WISI=;
  b=PN4+dE7CBJuTLial3GGOsZUhM9Nd7hxoUOxRfMYTds8uycgFTOSWN30C
   FOaW2otlCOPGfzHDS5Kch5c3/vMX3cANaen/Qmdg0RVcHtAsMQhaEPXPW
   DzQcdGl933adUwrBZX+rsyenHUFuP68BOiq6Rq9O/g2WAD5UhqRF1bu2s
   i9EIcJr8at6slQnT6/FM3fa0mXpPN1vh2gaBWAOLXlxOgAXDfU48PmFQr
   sdw6c0UbevF5u84wlCOmEdeLiihLgaAhqF/fiiFOLeui7eqMd4k4Sm5cK
   BReQ4pMCT2iDKGX4DZVSXUr9JdLzKVIPPDRcW3/Pd93PqXjnqg0+tEMwl
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="269816877"
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="269816877"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 20:27:46 -0700
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="553591830"
Received: from vshanmug-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.32.81])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 20:27:44 -0700
Message-ID: <a42f3b8eee77a769d9d95f25998108baeadf87e7.camel@intel.com>
Subject: Re: [PATCH 3/4] x86/sgx: Fine grained SGX MCA behavior for
 virtualization
From:   Kai Huang <kai.huang@intel.com>
To:     Zhiquan Li <zhiquan1.li@intel.com>, linux-sgx@vger.kernel.org,
        tony.luck@intel.com
Cc:     jarkko@kernel.org, dave.hansen@linux.intel.com, seanjc@google.com,
        fan.du@intel.com
Date:   Thu, 12 May 2022 15:27:41 +1200
In-Reply-To: <38d7bc14-80cb-b69d-753b-f8c0dc548dbf@intel.com>
References: <20220510031748.3181459-1-zhiquan1.li@intel.com>
         <c6b002cc4b6f979ffd0869f80742896fbe668376.camel@intel.com>
         <38d7bc14-80cb-b69d-753b-f8c0dc548dbf@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2022-05-12 at 10:19 +0800, Zhiquan Li wrote:
> On 2022/5/12 07:33, Kai Huang wrote:
> > > +			ret = force_sig_mceerr(BUS_MCEERR_AR, (void __user *)owner->vaddr,
> > > +					PAGE_SHIFT);
> > If I understand correctly, this sends signal to the userspace hypervisor, i.e.
> > Qemu?  Can you elaborate how is KVM supposed to inject the #MC to guest, instead
> > of Qemu process (the VM) being killed?
> > 
> 
> Yes, here we use the facility that Qemu already has.
> The basic call path as below:
> 
> sigbus_handler
>   kvm_on_sigbus
>     kvm_arch_on_sigbus_vcpu
>       qemu_ram_addr_from_host
>       kvm_physical_memory_addr_from_host
>       kvm_hwpoison_page_add
>       kvm_mce_inject
>         cpu_x86_inject_mce
> 
> 1. At first when Qemu init, it will register sigbus_handler() as its SIGBUS handler
>    at qemu_init_sigbus().
> 2. At sigbus_handler() it will filter-out the signal which siginfo->si_code is not
>    BUS_MCEERR_AO or BUS_MCEERR_AR, and then re-raise SIGBUS signal.
>    If the si_code is BUS_MCEERR_AO or BUS_MCEERR_AR, it will invoke
>    kvm_on_sigbus(siginfo->si_code, siginfo->si_addr), go on handling the signal.
> 3. kvm_on_sigbus() is a simple generic wrap which will call arch specific
>    kvm_arch_on_sigbus_vcpu()
> 4. kvm_arch_on_sigbus_vcpu() is x86 specific implementation, it will do following
>    1) Convert HVA (addr) to HPA (ram_addr)
>       ram_addr = qemu_ram_addr_from_host(addr)
>    2) Retrieve the GPA (paddr) as per HVA (addr)
>       kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)
>    3) Add the page including HWPoison HPA to its hwpoison_page_list
>       kvm_hwpoison_page_add(ram_addr)
>    4) Inject the #MC to guest with GPA and si_code
>       kvm_mce_inject(cpu, paddr, code)
>         cpu_x86_inject_mce()
> 
> The rest is guest kernel uses the existed MCA to handle the #MC. According to the
> physical address (in fact, GPA) find the applications and send kill signal if the
> #MC is SRAR.
> 
> So the intention of this patchset is to enrich the information when sending
> SIGBUS, so that VMM can use already existed facility to take a proper behavior.
> 
> 

Yes this makes sense.  Thanks for explaining!


-- 
Thanks,
-Kai


