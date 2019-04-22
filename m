Return-Path: <SRS0=gKhM=SY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41A91C282E1
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Apr 2019 16:26:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B25021738
	for <linux-sgx@archiver.kernel.org>; Mon, 22 Apr 2019 16:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555950403;
	bh=JEMFjRO0Pa+ynEuxrcJbn2OMjypI2OJSx48qtGPrCtQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=NLpFB7t0GxkFhlFrw+H7vKdtgzl99bTYl68NOV000iggxxMjUq85veVJdATIKfaLm
	 sydqFgZwmbxq6ZmDF8VXmDmT0Ct1MnagTOcT3+P7IakPJvm+N6IE/Wf5pfnieygxPR
	 EmzncehAqlVBswwIM20uKEjDrBtHHWwmwEyCjd7g=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbfDVQ0j (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 22 Apr 2019 12:26:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727069AbfDVQ0i (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 22 Apr 2019 12:26:38 -0400
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 288B7218FE
        for <linux-sgx@vger.kernel.org>; Mon, 22 Apr 2019 16:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555950397;
        bh=JEMFjRO0Pa+ynEuxrcJbn2OMjypI2OJSx48qtGPrCtQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=gjoMnb6oimB1UXsP+q67JhT9/D0zS5v1UAcav8Jbc04y8VHhDSijqiHIVZPFgO4NB
         hHgqrMALUnXhqapnqOzCQV899+aibi2rEi8de+l8w43aqsIm0IsA9oZx0FFUz7tZbW
         WeHY2JENlcB6R1VU5x4CmTiXb3Te7gGeRrR+OysQ=
Received: by mail-wr1-f52.google.com with SMTP id o12so13081421wrn.2
        for <linux-sgx@vger.kernel.org>; Mon, 22 Apr 2019 09:26:37 -0700 (PDT)
X-Gm-Message-State: APjAAAUADjWMG4G0xcr9DeE/+5qexe0uRnZVmF6gJYkMBai/N1+ViRXc
        eUNe8XBsSglzKUZzmX9WpDjKbvdV7qp2k0FOlupYHg==
X-Google-Smtp-Source: APXvYqwaVi+vNXltP2bE2dnmMdOSlfdSwesJN8KRUfOA7mCXt+en0NaYLY1S55edHS/S4oJ9g8vaYLFROh2X1WlG/18=
X-Received: by 2002:a5d:474b:: with SMTP id o11mr7809394wrs.309.1555950395519;
 Mon, 22 Apr 2019 09:26:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <20190418171059.GA20819@wind.enjellic.com> <09ebfa1d-c03d-c1fe-ff0f-d99287b6ec3c@intel.com>
 <20190419141732.GA2269@wind.enjellic.com> <CALCETrV=wAsyWxtxQJ7y0xNrzkE863hTfU6Ysej48Gk9yPFJZw@mail.gmail.com>
 <43aa8fdd-e777-74cb-e3f0-d36805ffa18b@fortanix.com> <alpine.DEB.2.21.1904192233390.3174@nanos.tec.linutronix.de>
 <8c5133bc-1301-24ca-418d-7151a6eac0e2@fortanix.com> <alpine.DEB.2.21.1904192248550.3174@nanos.tec.linutronix.de>
 <e1478f70-7e44-6e3e-2aaf-1b12a96328ed@fortanix.com> <2AE80EA3-799E-4808-BBE4-3872F425BCF8@amacapital.net>
 <49b28ca1-6e66-87d9-2202-84c58f13fb99@fortanix.com> <444537E3-4156-41FB-83CA-57C5B660523F@amacapital.net>
 <f9d93291-9b59-7b66-de9f-af92246f1c9c@fortanix.com> <alpine.DEB.2.21.1904192337160.3174@nanos.tec.linutronix.de>
 <5854e66a-950e-1b12-5393-d9cdd15367dc@fortanix.com>
In-Reply-To: <5854e66a-950e-1b12-5393-d9cdd15367dc@fortanix.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 22 Apr 2019 09:26:23 -0700
X-Gmail-Original-Message-ID: <CALCETrV7CcDnx1hVtmBnDNABG11GuMqyspJMMpV+zHpVeFu3ow@mail.gmail.com>
Message-ID: <CALCETrV7CcDnx1hVtmBnDNABG11GuMqyspJMMpV+zHpVeFu3ow@mail.gmail.com>
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> On Apr 19, 2019, at 2:56 PM, Jethro Beekman <jethro@fortanix.com> wrote:
>
>> On 2019-04-19 14:34, Thomas Gleixner wrote:
>> And how so? You create writeable AND executable memory. That's a nono an=
d
>> you can argue in circles, that's not going to change with any of your
>> proposed changes.
>
>> On 2019-04-19 14:38, Thomas Gleixner wrote:
>> You are working around LSM nothing else and that's just not going to fly=
.
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
>
> This works fine with v20 as-is. However, consider the equivalent of the
> PT-based flow:
>
> mmap(PROT_READ|PROT_EXEC)
> ioctl(EADD) <-- no error!

Indeed!

>
> It's not me that's working around the LSM, it's the SGX driver! It's
> writing to memory that's not marked writable! The fundamental issue here
> is that the SGX instruction set has several instructions that bypass the
> page table permission bits, and this is (naturally) confusing to any
> kind of reference monitor like the LSM framework. You can come up with
> similar scenarios that involve PROT_READ|PROT_WRITE|PROT_EXEC or
> ptrace(PTRACE_POKETEXT). So, clearly, the proper way to fix this failure
> of complete mediation is by enforcing appropriate page-table permissions
> even on the SGX instructions that don't do it themselves. Just make any
> implicit memory access look like a regular memory access and now
> everyone is on the same page (pun intended).
>

I agree that we should do this.  But then what?  Once this gets fixed,
the ioctl(EADD) fails and the driver becomes rather less useful, and
we feel rather silly if we=E2=80=99ve merged it in this state.

So I think we need a better EADD ioctl that explicitly does work on
PROT_READ|PROT_EXEC enclave memory but makes up for by validating the
*source* of the data.  The effect will be similar to mapping a
labeled, appraised, etc file as PROT_EXEC.  Maybe, in extreme
pseudocode:

fd =3D open(=E2=80=9C/dev/sgx/enclave=E2=80=9D);
ioctl(fd, SGX_CREATE_FROM_FILE, file_fd);
// fd now inherits the LSM label from the file, or is otherwise marked.
mmap(fd, PROT_READ|PROT_EXEC, ...);

I suppose that an alternative would be to delegate all the EADD calls
to a privileged daemon, but that=E2=80=99s nasty.
