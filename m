Return-Path: <SRS0=zBz/=O2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67707C43387
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Dec 2018 19:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33ACE21473
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Dec 2018 19:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545076525;
	bh=oEHPmI/Nz9EMBhsPz3C2AbHb49g5SoQ6GO8ODFh48g8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=nKFaG0rugSwjBjrAfHCoImyVWmEI+YOzfI644vtybK6+NmCD/CTmxbpyLIuNrn5tc
	 8HsjUfOmJJrdClRikZ1gxFA2apDvMjlR9iE3qjy5UYE3Wy32XTFkaFEVUJqk72fCQr
	 mSG/h+CqDzyHOUq4I7ZbJWoB0gABn1zk85OBabng=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbeLQTzY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Dec 2018 14:55:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:56058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726989AbeLQTzY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Dec 2018 14:55:24 -0500
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C13D021855
        for <linux-sgx@vger.kernel.org>; Mon, 17 Dec 2018 19:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545076524;
        bh=oEHPmI/Nz9EMBhsPz3C2AbHb49g5SoQ6GO8ODFh48g8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qMtzzcpkvg5C5XVG22Ll3D2DL6X0vmfBQZMv1830OvGqy/tPaLzrLGoud/KyqaFiK
         j4JfegQJ9NeJ2+pU18wUSovmasUwvWWtYFBCo9c9p5wOSzinJTiwQ+dwAJBtoLNR5a
         aGxsWSNIfs4OF4eVkqN4fZhE3LR3BZ9WiK7tS/gw=
Received: by mail-wm1-f42.google.com with SMTP id y185so5513536wmd.1
        for <linux-sgx@vger.kernel.org>; Mon, 17 Dec 2018 11:55:23 -0800 (PST)
X-Gm-Message-State: AA+aEWZuon3aVemxycgjfLM8382RzWqd5Ol81eQnFw2/gHrPjUtExAet
        sGKeCp/K1X7pOepNLTpH7G+W3TjV9hdQTEpk7EOXzQ==
X-Google-Smtp-Source: AFSGD/XXTj87WebmVQn0RRQpblxcyYw7HskoN+Pza4JS6E0aP/AFJHQYjAn48WimC051nDq/MBRhKiz7+cn4xCTKZzQ=
X-Received: by 2002:a1c:aa0f:: with SMTP id t15mr425825wme.108.1545076522052;
 Mon, 17 Dec 2018 11:55:22 -0800 (PST)
MIME-Version: 1.0
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com> <7d5cde02-4649-546b-0f03-2d6414bb80b5@intel.com>
 <20181217180102.GA12560@linux.intel.com> <20181217183613.GD12491@linux.intel.com>
 <20181217184333.GA26920@linux.intel.com> <ccfb67a0-fd8d-82c8-8018-fd68e901f287@intel.com>
 <CALCETrX0W4dhFJBHEbDbKed_QZxmw6ZNMajfsoVgqGqhMB0nDg@mail.gmail.com>
 <beea8ad3-a607-5478-ad87-b8dd33e86146@intel.com> <20181217194913.GD29785@linux.intel.com>
 <16fdd37a-b9cc-1045-1497-2cfff6af176a@intel.com>
In-Reply-To: <16fdd37a-b9cc-1045-1497-2cfff6af176a@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 17 Dec 2018 11:55:09 -0800
X-Gmail-Original-Message-ID: <CALCETrUhVDxMAtpyn5ahsTFwhJkzWxKa5Ur8q4FuVaKLmSyYHQ@mail.gmail.com>
Message-ID: <CALCETrUhVDxMAtpyn5ahsTFwhJkzWxKa5Ur8q4FuVaKLmSyYHQ@mail.gmail.com>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, nhorman@redhat.com,
        npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>,
        shay.katz-zamir@intel.com,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, mark.shanahan@intel.com,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 17, 2018 at 11:53 AM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 12/17/18 11:49 AM, Jarkko Sakkinen wrote:
> >> Yeah, the code is built to have one VMA and only one VMA per enclave.
> >> You need to go over the origin of this restriction and what enforces this.
> > It is before ECREATE but after that you can split it with mprotect().
> >
> > Lets take an example. I'm not sure how we would acquire mm efficiently
> > in sgx_encl_page_reclaim() otherwise than having it as a field in encl.
>
> You're effectively rebuilding reverse-mapping infrastructure here.  It's
> a frequent thing for the core VM to need to go from 'struct page' back
> to the page tables mapping it.  For that we go (logically)
> page->{anon_vma,mapping}->vma->vm_mm->pagetable.

This is a bit outside my expertise here, but doesn't
unmap_mapping_range() do exactly what SGX wants?
