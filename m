Return-Path: <SRS0=Uuw6=4I=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF8B9C11D0C
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Feb 2020 18:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B83B208E4
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Feb 2020 18:33:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Nc3sqFiK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728756AbgBTSdi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Feb 2020 13:33:38 -0500
Received: from linux.microsoft.com ([13.77.154.182]:38024 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbgBTSdi (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 20 Feb 2020 13:33:38 -0500
Received: from [10.131.86.40] (unknown [131.107.174.40])
        by linux.microsoft.com (Postfix) with ESMTPSA id CF78620B9C02;
        Thu, 20 Feb 2020 10:33:36 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CF78620B9C02
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1582223617;
        bh=AWFTKff2D71eTULXfKD0OOx5tsIJ1Cyrn7ArYV67Ud8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Nc3sqFiKUhHLMxzD7NGjTh04dBiuYyLoB/4Vawy/wGZAhe6xGrmX4B1Y+OG1hYmcb
         SJdjy8FViujaAPSrUNHd1OKDV+vCN7ZzQlv7ftlYhMDVkKsOHzKT/uJeELDuTaL0ue
         M+k9OfRLbVBc2SqoIj6UTWw70i+LG/zxQ55ftSoA=
Subject: Re: [PATCH v26 10/22] x86/sgx: Linux Enclave Driver
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>
References: <20200209212609.7928-1-jarkko.sakkinen@linux.intel.com>
 <20200209212609.7928-11-jarkko.sakkinen@linux.intel.com>
 <15074c16-4832-456d-dd12-af8548e46d6d@linux.microsoft.com>
 <20200220181345.GD3972@linux.intel.com>
From:   Jordan Hand <jorhand@linux.microsoft.com>
Message-ID: <7738b3cf-fb32-5306-5740-59974444e327@linux.microsoft.com>
Date:   Thu, 20 Feb 2020 10:33:36 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200220181345.GD3972@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 2/20/20 10:13 AM, Sean Christopherson wrote:
> On Tue, Feb 18, 2020 at 07:26:31PM -0800, Jordan Hand wrote:
>> During mprotect (in mm/mprotect.c line 525) the following checks if
>> READ_IMPLIES_EXECUTE and a PROT_READ is being requested. If so and
>> VM_MAYEXEC is set, it also adds PROT_EXEC to the request.
>>
>> 	if (rier && (vma->vm_flags & VM_MAYEXEC))
>> 		prot |= PROT_EXEC;
>>
>> But if we look at sgx_encl_page_alloc(), we see vm_max_prot_bits is set
>> without taking VM_MAYEXEC into account:
>>
>> 	encl_page->vm_max_prot_bits = calc_vm_prot_bits(prot, 0);
>>
>> sgx_encl_may_map() checks that the requested protection can be added with:
>>
>> 	if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
>> 		return -EACCESS
>>
>> This means that for any process where READ_IMPLIES_EXECUTE is set and
>> page where (vma->vm_flags & VM_MAYEXEC) == true, mmap/mprotect calls to
>> that request PROT_READ on a page that was not added with PROT_EXEC will
>> fail.
> 
> I could've sworn this was discussed on the SGX list at one point, but
> apparently we only discussed it internally.  Anyways...
> 
> More than likely, the READ_IMPLIES_EXECUTE (RIE) crud rears its head
> because part of the enclave loader is written in assembly.  Unless
> explicitly told otherwise, the linker assumes that any program with
> assembly code may need an executable stack, which leads to the RIE
> personality being set for the process.  Here's a fantastic write up for
> more details: https://www.airs.com/blog/archives/518
> 
> There are essentially two paths we can take:
> 
>  1) Exempt EPC pages from RIE during mmap()/mprotect(), i.e. don't add
>     PROT_EXEC for enclaves.
> 
>  2) Punt the issue to userspace.
> 
> Option (1) is desirable in some ways:
> 
>   - Enclaves will get an executable stack if and only if the loader/creator
>     intentionally configures it to have an executable stack.
> 
>   - Separates enclaves from the personality of the loader.
> 
>   - Userspace doesn't have to do anything for the common case of not
>     wanting an executable stack for its enclaves.
> 
> The big down side to (1) is that it'd require an ugly hook in architecture
> agnostic code.  And arguably, it reduces the overall security of the
> platform (more below).
> 
> For (2), userspace has a few options:
> 
>  a) Tell the linker the enclave loader doesn't need RIE, either via a .note
>     in assembly files or via the global "-z noexecstack" flag.
> 
>  b) Spawn a separate process to run/map the enclave if the enclave loader
>     needs RIE.
> 
>  c) Require enclaves to allow PROT_EXEC on all pages.  Note, this is an
>     absolutely terrible idea and only included for completeness.
> 
> As shown by the lack of a mmap()/mprotect() hook in this series to squash
> RIE, we chose option (2).  Given that enclave loaders are not legacy code
> and hopefully following decent coding practices, option (2a) should suffice
> for all loaders.  The security benefit mentioned above is that forcing
> enclave loaders to squash RIE eliminates an exectuable stack as an attack
> vector on the loader.

I see your point and I do agree that there are security benefits to (2a)
and I think we could do that for our loader. That said, it does concern
me that this breaks perfectly valid userspace behavior. If a userspace
process decides to use RIE, I don't know that the SGX driver should
disobey that decision.

So option (3) would be to just honor RIE for enclave pages and when page
permissions are set to PROT_READ in sgx_encl_page_alloc and RIE is set,
also add PROT_EXEC.

I understand your concerns that this using RIE is bad security practice
and I'm not convinced that (3) is the way to go, but from a philosophy
perspective I don't know that the kernel should be in the business of
stopping userspace from doing valid things.

If option (3) can't/shouldn't be done for some reason, option (1) at
least keeps from breaking expected userspace behavior. But I do agree
that (1) is ugly to implement.

-Jordan
