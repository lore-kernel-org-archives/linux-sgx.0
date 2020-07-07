Return-Path: <SRS0=kNj5=AS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD811C433DF
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jul 2020 04:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AADEA20684
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Jul 2020 04:06:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fbbH+nMU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgGGEGT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 7 Jul 2020 00:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbgGGEGT (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 7 Jul 2020 00:06:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06812C061755;
        Mon,  6 Jul 2020 21:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zVZLs0N75aZV67cHh+dPIHohMDTzmdFMj5VSVF1NIIE=; b=fbbH+nMUdsi61xBpyAWZ3pwwVH
        RcP5goKiCyW+CRG6U9h5HWCFdyU+6CeAngxeyk4mKEo0Ikxe738kaJPNlAkgu/yVDbVTUH6kaba8A
        TcL7cBxYSgt/4V2PoGfEyJQUelVVAa4Qhzay8lmHjYTMnSCXfvWvweIr8+5z8KFrfNSeo9Q31MyGf
        5rih/kL54q1ouZUoKRNi8rvVcyH6J0Cai5xSPnjIejds8/Ba3fL6/sMEB8gd9Xy3AhLMYBToZShyw
        QXQJjyu/jDt0iWZ2nlS95xsjZM0cAcdP+feB3S+6B3vn+ILQUpIfyYMLv8S1hssK/1oLPZ5zvqBon
        o+Sunugg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jses2-0005Cw-0f; Tue, 07 Jul 2020 04:06:14 +0000
Date:   Tue, 7 Jul 2020 05:06:13 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v35 23/24] docs: x86/sgx: Document SGX micro architecture
 and kernel internals
Message-ID: <20200707040613.GH25523@casper.infradead.org>
References: <20200707033747.142828-1-jarkko.sakkinen@linux.intel.com>
 <20200707033747.142828-24-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707033747.142828-24-jarkko.sakkinen@linux.intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Jul 07, 2020 at 06:37:46AM +0300, Jarkko Sakkinen wrote:
> +*Software Guard eXtensions (SGX)* is a set of instructions that enable ring-3

I can never remember which way up intel numbers their rings.
Is that user mode or kernel mode?

> +applications to set aside private regions of code and data. These regions are
> +called enclaves. An enclave can be entered to a fixed set of entry points. Only

entered through?

> +a CPU running inside the enclave can access its code and data.
> +
> +The support can be determined by
> +
> +	``grep sgx /proc/cpuinfo``
> +
> +Enclave Page Cache
> +==================
> +
> +SGX utilizes an *Enclave Page Cache (EPC)* to store pages that are associated
> +with an enclave. It is contained in a BIOS reserved region of physical memory.
> +Unlike pages used for regular memory, pages can only be accessed outside the
> +enclave for different purposes with the instructions **ENCLS**, **ENCLV** and
> +**ENCLU**.
> +
> +Direct memory accesses to an enclave can be only done by a CPU executing inside
> +the enclave. An enclave can be entered with **ENCLU[EENTER]** to a fixed set of
> +entry points. However, a CPU executing inside the enclave can do outside memory
> +accesses.

This is rather tortured.  I think what you're trying to say here is:

Only a CPU executing inside an enclave can access memory belonging to the
enclave.  The CPU may access memory outside the enclave as long as it does
not attempt to access memory which is inside a different enclave.

> +Enclave Page Cache Map
> +----------------------
> +
> +The processor tracks EPC pages via the *Enclave Page Cache Map (EPCM)*.  EPCM
> +contains an entry for each EPC page, which describes the owning enclave, access
> +rights and page type among the other things.
> +
> +The permissions from EPCM is consulted if and only if walking the kernel page
> +tables succeeds. The total permissions are thus a conjunction between page table
> +and EPCM permissions.
> +
> +For all intents and purposes the SGX architecture allows the processor to
> +invalidate all EPCM entries at will, i.e. requires that software be prepared to
> +handle an EPCM fault at any time. The contents of EPC are encrypted with an
> +ephemeral key, which is lost on power transitions.

The SGX architecture allows the processor to invalidate any EPCM entry
at any time.  Sotware must be prepared to handle the resulting EPCM fault.
The contents of EPC are encrypted with an ephemeral key, which is lost on
power transitions.

(can you be a bit more specific about power transitions?  do you mean
suspend/resume?  hibernate/wake?  poweroff/poweron?  what about reset?
surely you don't mean S1?  or do you?)

