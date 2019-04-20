Return-Path: <SRS0=VsxJ=SW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C283C282DD
	for <linux-sgx@archiver.kernel.org>; Sat, 20 Apr 2019 05:42:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E1A72087F
	for <linux-sgx@archiver.kernel.org>; Sat, 20 Apr 2019 05:42:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbfDTFm1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 20 Apr 2019 01:42:27 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:42806 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbfDTFm1 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Sat, 20 Apr 2019 01:42:27 -0400
Received: from pd9ef12d2.dip0.t-ipconnect.de ([217.239.18.210] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hHilT-0002pw-F9; Sat, 20 Apr 2019 07:42:15 +0200
Date:   Sat, 20 Apr 2019 07:42:13 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Jethro Beekman <jethro@fortanix.com>
cc:     Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        "Dr. Greg" <greg@enjellic.com>,
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
In-Reply-To: <5854e66a-950e-1b12-5393-d9cdd15367dc@fortanix.com>
Message-ID: <alpine.DEB.2.21.1904200727410.3174@nanos.tec.linutronix.de>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com> <20190418171059.GA20819@wind.enjellic.com> <09ebfa1d-c03d-c1fe-ff0f-d99287b6ec3c@intel.com> <20190419141732.GA2269@wind.enjellic.com> <CALCETrV=wAsyWxtxQJ7y0xNrzkE863hTfU6Ysej48Gk9yPFJZw@mail.gmail.com>
 <43aa8fdd-e777-74cb-e3f0-d36805ffa18b@fortanix.com> <alpine.DEB.2.21.1904192233390.3174@nanos.tec.linutronix.de> <8c5133bc-1301-24ca-418d-7151a6eac0e2@fortanix.com> <alpine.DEB.2.21.1904192248550.3174@nanos.tec.linutronix.de> <e1478f70-7e44-6e3e-2aaf-1b12a96328ed@fortanix.com>
 <2AE80EA3-799E-4808-BBE4-3872F425BCF8@amacapital.net> <49b28ca1-6e66-87d9-2202-84c58f13fb99@fortanix.com> <444537E3-4156-41FB-83CA-57C5B660523F@amacapital.net> <f9d93291-9b59-7b66-de9f-af92246f1c9c@fortanix.com> <alpine.DEB.2.21.1904192337160.3174@nanos.tec.linutronix.de>
 <5854e66a-950e-1b12-5393-d9cdd15367dc@fortanix.com>
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
> On 2019-04-19 14:34, Thomas Gleixner wrote:
> > And how so? You create writeable AND executable memory. That's a nono and
> > you can argue in circles, that's not going to change with any of your
> > proposed changes.
> 
> On 2019-04-19 14:38, Thomas Gleixner wrote:
> > You are working around LSM nothing else and that's just not going to fly.
> 
> Based on your comments, I'm still unsure if we're on the same page with
> regards to what I'm proposing.
> 
> Here's a regular non-SGX flow that LSM would likely prevent:
> 
> mmap(PROT_READ|PROT_WRITE)
> memcpy()
> mmap(PROT_READ|PROT_EXEC) <-- denied by LSM
> 
> Or just something based on regular PT permissions:
> 
> mmap(PROT_READ|PROT_EXEC)
> memcpy() <-- SIGSEGV
> 
> Now, the equivalent for SGX:
> 
> mmap(PROT_READ|PROT_WRITE)
> ioctl(EADD)
> mmap(PROT_READ|PROT_EXEC) <-- denied by LSM

This is completely irrelevant, really.

The point is that the SGX driver loads and executes arbitrary data which is
handed in from user space via an ioctl w/o any chance of verifying where
that comes from.

What Andy proposed is to open a file with the SGX payload and hand in the
file descriptor. That way LSM can decide whether this is allowed or denied
based on the file descriptor and whatever the security model/policy is in a
particular setup.

Right know the SGX driver and its proposed API prevent any form of LSM
auditing and whatever permission checks you had in mind won't change that
at all.

Thanks,

	tglx
