Return-Path: <SRS0=YVcv=UJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9948C4321D
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 19:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97260207E0
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 19:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560194140;
	bh=bwqpF3I6lO7fWvagsxvA4v6sU5wPG0JemCNLZlDlq8Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=SHb2MrDuevnoVaBM37Lm8SU1pcAbEshGvYVx5m666lEsXyxMQwdQbz2hkmXkrV9Q1
	 yI0jIfZoGHI5/ddYV7sfPM4qoiMes7TTsBUu9FvD64BpsvVBy+KU2VgBiDhSUsmPPa
	 XFZXhHVqdCl8mVSJ4HakHLcZ2JaoZQlewqFdR2tk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389199AbfFJTPk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Jun 2019 15:15:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388915AbfFJTPj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 Jun 2019 15:15:39 -0400
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2E81212F5
        for <linux-sgx@vger.kernel.org>; Mon, 10 Jun 2019 19:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560194139;
        bh=bwqpF3I6lO7fWvagsxvA4v6sU5wPG0JemCNLZlDlq8Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Xe13SfBQ9jVPup9P6gfDqODjAROjYF3feQ8rc1jxRgFzRjx0SSAYAA8Jr62rJv6fa
         TWmlfY7NjWTQp+eMeBZuaoImCepyydT+2ygKG9WIsgbUZPpJ+RYh78sAgh3UvRojnV
         wbQM5WgAh/dC0yeqr26jVvR8zt2xgUM4Szj4xvIQ=
Received: by mail-wr1-f50.google.com with SMTP id n4so10356041wrs.3
        for <linux-sgx@vger.kernel.org>; Mon, 10 Jun 2019 12:15:38 -0700 (PDT)
X-Gm-Message-State: APjAAAUBxJbELyqpTHBpvZOeiIizi/5J+1nhGY4SktfGVDnejLocB2Lw
        bhb9hSSIxGDDJnQ+3fmAOG7rie2+jTMN1XHQuDTlUA==
X-Google-Smtp-Source: APXvYqypfa4skx8hkgphvRTlO10XR3vZ0R1oIgntdrw7LesWhWM3R3rndKtbU7gLtSJsZ4estO+TO7D8oT+MoCFoMvU=
X-Received: by 2002:a5d:6207:: with SMTP id y7mr26919319wru.265.1560194137485;
 Mon, 10 Jun 2019 12:15:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190606021145.12604-1-sean.j.christopherson@intel.com>
 <20190606021145.12604-3-sean.j.christopherson@intel.com> <960B34DE67B9E140824F1DCDEC400C0F65500E13@ORSMSX116.amr.corp.intel.com>
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F65500E13@ORSMSX116.amr.corp.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 10 Jun 2019 12:15:25 -0700
X-Gmail-Original-Message-ID: <CALCETrWv9FYDtiHMfnfH==jE00tt7F22t-zcnP+XjfRCQgLr7A@mail.gmail.com>
Message-ID: <CALCETrWv9FYDtiHMfnfH==jE00tt7F22t-zcnP+XjfRCQgLr7A@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/5] x86/sgx: Require userspace to define enclave
 pages' protection bits
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jun 10, 2019 at 11:29 AM Xing, Cedric <cedric.xing@intel.com> wrote:
>
> > From: Christopherson, Sean J
> > Sent: Wednesday, June 05, 2019 7:12 PM
> >
> > +/**
> > + * sgx_map_allowed - check vma protections against the associated
> > enclave page
> > + * @encl:    an enclave
> > + * @start:   start address of the mapping (inclusive)
> > + * @end:     end address of the mapping (exclusive)
> > + * @prot:    protection bits of the mapping
> > + *
> > + * Verify a userspace mapping to an enclave page would not violate the
> > +security
> > + * requirements of the *kernel*.  Note, this is in no way related to
> > +the
> > + * page protections enforced by hardware via the EPCM.  The EPCM
> > +protections
> > + * can be directly extended by the enclave, i.e. cannot be relied upon
> > +by the
> > + * kernel for security guarantees of any kind.
> > + *
> > + * Return:
> > + *   0 on success,
> > + *   -EACCES if the mapping is disallowed
> > + */
> > +int sgx_map_allowed(struct sgx_encl *encl, unsigned long start,
> > +                 unsigned long end, unsigned long prot) {
> > +     struct sgx_encl_page *page;
> > +     unsigned long addr;
> > +
> > +     prot &= (VM_READ | VM_WRITE | VM_EXEC);
> > +     if (!prot || !encl)
> > +             return 0;
> > +
> > +     mutex_lock(&encl->lock);
> > +
> > +     for (addr = start; addr < end; addr += PAGE_SIZE) {
> > +             page = radix_tree_lookup(&encl->page_tree, addr >>
> > PAGE_SHIFT);
> > +
> > +             /*
> > +              * Do not allow R|W|X to a non-existent page, or protections
> > +              * beyond those of the existing enclave page.
> > +              */
> > +             if (!page || (prot & ~page->prot))
> > +                     return -EACCES;
>
> In SGX2, pages will be "mapped" before being populated.
>
> Here's a brief summary for those who don't have enough background on how new EPC pages could be added to a running enclave in SGX2:
>   - There are 2 new instructions - EACCEPT and EAUG.
>   - EAUG is used by SGX module to add (augment) a new page to an existing enclave. The newly added page is *inaccessible* until the enclave *accepts* it.
>   - EACCEPT is the instruction for an enclave to accept a new page.
>
> And the s/w flow for an enclave to request new EPC pages is expected to be something like the following:
>   - The enclave issues EACCEPT at the linear address that it would like a new page.
>   - EACCEPT results in #PF, as there's no page at the linear address above.
>   - SGX module is notified about the #PF, in form of its vma->vm_ops->fault() being called by kernel.
>   - SGX module EAUGs a new EPC page at the fault address, and resumes the enclave.
>   - EACCEPT is reattempted, and succeeds at this time.

This seems like an odd workflow.  Shouldn't the #PF return back to
untrusted userspace so that the untrusted user code can make its own
decision as to whether it wants to EAUG a page there as opposed to,
say, killing the enclave or waiting to keep resource usage under
control?
