Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 872A7C433DB
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Mar 2021 10:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FA5D61A05
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Mar 2021 10:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236317AbhCXKJ5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 24 Mar 2021 06:09:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44294 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235499AbhCXKJ0 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 24 Mar 2021 06:09:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616580566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+BxpC3ZDfxmFtDdT2d7R9frgu/mhTDp3jIrR2QlPinw=;
        b=JEFEyvc2Yvf5AIhs3n5I8uQLu/hiK9gfh/zIHZCVsN6iE5lTFJQK6P38TXAYxeQGbBMqzD
        82J1MZ41cDOob2EoL0su0ZpfI+1huReLe7EGUoA+CRp9L+nyPzdAjkU1JgBCdYpMjUtWR/
        pqdivCOgGUCoPNVqHcO45xcFCD+ADXI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-AMF5tJcKONCbKyTRXB25Bw-1; Wed, 24 Mar 2021 06:09:24 -0400
X-MC-Unique: AMF5tJcKONCbKyTRXB25Bw-1
Received: by mail-wm1-f72.google.com with SMTP id a65so236171wmh.1
        for <linux-sgx@vger.kernel.org>; Wed, 24 Mar 2021 03:09:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+BxpC3ZDfxmFtDdT2d7R9frgu/mhTDp3jIrR2QlPinw=;
        b=ra9/O2bhUdRY8uPmlvgpwUQeO8phHQ/yVHqM/iHbA0YCYgf/k2xrYy7xkn42nNGcOf
         ojyfcnw8/PdcLWhh0bhv52k/2cSl1N/k7kSpwmZVL+zRmJn8S3XuCfVLiyp2bLc1TVIG
         YrUz39aa6wsIfCE5jqjnv8UQjPbIkhOIDETBh+teVe3hT9MBvMXTu164/94fSfxVPtxF
         G871EKg7CR0/yzyZY7V5MjwAS4oZJiVHJBdlght4IldQKMyhD9qAIQWIzxy+hHX/222Y
         izlBnatDCfg8Owli7zFsGrSuvBAYiKMjuZ7H3ZuBEqIpZTw3JgODGYoqDSgs+qzx6HBa
         cBiQ==
X-Gm-Message-State: AOAM533eaMMYtZG981RYFx/E23QO11CY2bUBPO7S1J7ilxeObMl0b/w9
        j7WxhNEK7znJKXqzEfKlqmCO6d02WXIOXUJ1DqcHKeRXOjBTLw7/gvCL+NRDP4w7pk0H5PNzDVE
        1FCqGBTw9oKO3/7uNsyL/
X-Received: by 2002:adf:f711:: with SMTP id r17mr2605292wrp.358.1616580563246;
        Wed, 24 Mar 2021 03:09:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhbNUzMrdZ/nYp6RmcFVhoHLDvcxw6XSTkNZNhDP+Yg0qhxax1ioWcfogIwOuawdIw+GBjdw==
X-Received: by 2002:adf:f711:: with SMTP id r17mr2605269wrp.358.1616580563035;
        Wed, 24 Mar 2021 03:09:23 -0700 (PDT)
Received: from [192.168.1.124] ([93.56.169.140])
        by smtp.gmail.com with ESMTPSA id a14sm2662399wrg.84.2021.03.24.03.09.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 03:09:22 -0700 (PDT)
To:     Kai Huang <kai.huang@intel.com>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
References: <YFjoZQwB7e3oQW8l@google.com> <20210322191540.GH6481@zn.tnic>
 <YFjx3vixDURClgcb@google.com> <20210322210645.GI6481@zn.tnic>
 <20210323110643.f29e214ebe8ec7a4a3d0bc2e@intel.com>
 <20210322223726.GJ6481@zn.tnic>
 <20210323121643.e06403a1bc7819bab7c15d95@intel.com>
 <YFoNCvBYS2lIYjjc@google.com> <20210323160604.GB4729@zn.tnic>
 <YFoVmxIFjGpqM6Bk@google.com> <20210323163258.GC4729@zn.tnic>
 <b35f66a10ecc07a1eecb829912d5664886ca169b.camel@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-ID: <236c0aa9-92f2-97c8-ab11-d55b9a98c931@redhat.com>
Date:   Wed, 24 Mar 2021 11:09:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <b35f66a10ecc07a1eecb829912d5664886ca169b.camel@intel.com>
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 24/03/21 10:38, Kai Huang wrote:
> Hi Sean, Boris, Paolo,
> 
> Thanks for the discussion. I tried to digest all your conversations and
> hopefully I have understood you correctly. I pasted the new patch here
> (not full patch, but relevant part only). I modified the error msg, added
> some writeup to Documentation/x86/sgx.rst, and put Sean's explanation of this
> bug to the commit msg (per Paolo). I am terrible Documentation writer, so
> please help to check and give comments. Thanks!

I have some phrasing suggestions below but that was actually pretty good.

> ---
> commit 1e297a535bcb4f51a08343c40207520017d85efe (HEAD)
> Author: Kai Huang <kai.huang@intel.com>
> Date:   Wed Jan 20 03:40:53 2021 +0200
> 
>      x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()
>      
>      EREMOVE takes a page and removes any association between that page and
>      an enclave.  It must be run on a page before it can be added into
>      another enclave.  Currently, EREMOVE is run as part of pages being freed
>      into the SGX page allocator.  It is not expected to fail.
>      
>      KVM does not track how guest pages are used, which means that SGX
>      virtualization use of EREMOVE might fail.  Specifically, it is
>      legitimate that EREMOVE returns SGX_CHILD_PRESENT for EPC assigned to
>      KVM guest, because KVM/kernel doesn't track SECS pages.
>
>      Break out the EREMOVE call from the SGX page allocator.  This will allow
>      the SGX virtualization code to use the allocator directly.  (SGX/KVM
>      will also introduce a more permissive EREMOVE helper).

Ok, I think I got the source of my confusion.  The part in parentheses
is the key.  It was not clear that KVM can deal with EREMOVE failures
*without printing the error*.  Good!

>      Implement original sgx_free_epc_page() as sgx_encl_free_epc_page() to be
>      more specific that it is used to free EPC page assigned host enclave.
>      Replace sgx_free_epc_page() with sgx_encl_free_epc_page() in all call
>      sites so there's no functional change.
>      
>      Improve error message when EREMOVE fails, and kernel is about to leak
>      EPC page, which is likely a kernel bug.  This is effectively a kernel
>      use-after-free of EPC, and due to the way SGX works, the bug is detected
>      at freeing.  Rather than add the page back to the pool of available EPC,
>      the kernel intentionally leaks the page to avoid additional errors in
>      the future.
>      
>      Also add documentation to explain to user what is the bug and suggest
>      user what to do when this bug happens, although extremely unlikely.

Rewritten:

EREMOVE takes a page and removes any association between that page and
an enclave.  It must be run on a page before it can be added into
another enclave.  Currently, EREMOVE is run as part of pages being freed
into the SGX page allocator.  It is not expected to fail, as it would
indicate a use-after-free of EPC.  Rather than add the page back to the
pool of available EPC, the kernel intentionally leaks the page to avoid
additional errors in the future.

However, KVM does not track how guest pages are used, which means that SGX
virtualization use of EREMOVE might fail.  Specifically, it is
legitimate that EREMOVE returns SGX_CHILD_PRESENT for EPC assigned to
KVM guest, because KVM/kernel doesn't track SECS pages.

To allow SGX/KVM to introduce a more permissive EREMOVE helper and to
let the SGX virtualization code use the allocator directly,
break out the EREMOVE call from the SGX page allocator.  Rename the
original sgx_free_epc_page() to sgx_encl_free_epc_page(),
indicating that it is used to free EPC page assigned host enclave.
Replace sgx_free_epc_page() with sgx_encl_free_epc_page() in all call
sites so there's no functional change.

At the same time improve error message when EREMOVE fails, and add
documentation to explain to user what is the bug and suggest user what
to do when this bug happens, although extremely unlikely.

> +Although extremely unlikely, EPC leaks can happen if kernel SGX bug happens,
> +when a WARNING with below message is shown in dmesg:

Remove "Although extremely unlikely".

> +"...EREMOVE returned ..., kernel bug likely.  EPC page leaked, SGX may become
> +unusuable.  Please refer to Documentation/x86/sgx.rst for more information."
> +
> +This is effectively a kernel use-after-free of EPC, and due to the way SGX
> +works, the bug is detected at freeing. Rather than add the page back to the pool
> +of available EPC, the kernel intentionally leaks the page to avoid additional
> +errors in the future.
> +
> +When this happens, kernel will likely soon leak majority of EPC pages, and SGX
> +will likely become unusable. However while this may be fatal to SGX, other
> +kernel functionalities are unlikely to be impacted, and should continue to work.
> +
> +As a result, when this happpens, user should stop running any new SGX workloads,
> +(or just any new workloads), and migrate all valuable workloads, for instance,
> +virtual machines, to other places.

Remove everything starting with "for instance".

  Although a machine reboot can recover all
> +EPC, debugging and fixing this bug is appreciated.

Replace the second part with "the bug should be reported to the Linux developers".
The poor user is not expected to debug SGX. ;)

> +/* Error message for EREMOVE failure, when kernel is about to leak EPC page */
> +#define EREMOVE_ERROR_MESSAGE \
> +       "EREMOVE returned %d (0x%x), kernel bug likely.  EPC page leaked, SGX may become
> unusuable.  Please refer to Documentation/x86/sgx.rst for more information."

Rewritten:

EREMOVE returned %d and an EPC page was leaked; SGX may become unusable.
This is a kernel bug, refer to Documentation/x86/sgx.rst for more information.

Also please split it across multiple lines.

Paolo

