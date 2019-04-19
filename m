Return-Path: <SRS0=cz4p=SV=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6713C282E0
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Apr 2019 20:50:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9180E2171F
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Apr 2019 20:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfDSUu5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 19 Apr 2019 16:50:57 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:42346 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfDSUu5 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 19 Apr 2019 16:50:57 -0400
Received: from pd9ef12d2.dip0.t-ipconnect.de ([217.239.18.210] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hHaTD-0007hu-E7; Fri, 19 Apr 2019 22:50:51 +0200
Date:   Fri, 19 Apr 2019 22:50:50 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Jethro Beekman <jethro@fortanix.com>
cc:     Andy Lutomirski <luto@kernel.org>, "Dr. Greg" <greg@enjellic.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
In-Reply-To: <8c5133bc-1301-24ca-418d-7151a6eac0e2@fortanix.com>
Message-ID: <alpine.DEB.2.21.1904192248550.3174@nanos.tec.linutronix.de>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com> <20190418171059.GA20819@wind.enjellic.com> <09ebfa1d-c03d-c1fe-ff0f-d99287b6ec3c@intel.com> <20190419141732.GA2269@wind.enjellic.com> <CALCETrV=wAsyWxtxQJ7y0xNrzkE863hTfU6Ysej48Gk9yPFJZw@mail.gmail.com>
 <43aa8fdd-e777-74cb-e3f0-d36805ffa18b@fortanix.com> <alpine.DEB.2.21.1904192233390.3174@nanos.tec.linutronix.de> <8c5133bc-1301-24ca-418d-7151a6eac0e2@fortanix.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 19 Apr 2019, Jethro Beekman wrote:
> On 2019-04-19 13:39, Thomas Gleixner wrote:
> > On Fri, 19 Apr 2019, Jethro Beekman wrote:
> > 
> >> On 2019-04-19 08:27, Andy Lutomirski wrote:
> >>> There are many,
> >>> many Linux systems that enforce a policy that *all* executable text
> >>> needs to come from a verified source.  On these systems, you can't
> >>> mmap some writable memory, write to it, and then change it to
> >>> executable.
> >>
> >> How is this implemented on those systems? AFAIK there's no kernel config
> >> option that changes the semantics of mmap as you describe.
> > 
> > That has nothing to do with mmap() semantics. You mmap() writeable memory
> > and then you change the permissions via mprotect(). mprotect() calls into
> > LSM and depending on policy and security model this will reject the
> > request.
> > 
> > Andy was pointing out that the SGX ioctl bypasses the LSM mechanics which
> > is obviously a bad thing.
> 
> We could modify the driver such that when you call ioctl EADD, the page
> table permissions need to be the PAGEINFO.SECINFO.FLAGS | PROT_WRITE,
> otherwise you get EPERM or so. After EADD, if you want, you can restrict
> the page table permissions again using mprotect but the page table
> permissions don't really matter for SGX.

And the point of that is? That you still can cirumvent LSM for feeding
executable code into SGX.

No, we are not making special cases and exceptions for SGX.

Thanks,

	tglx
