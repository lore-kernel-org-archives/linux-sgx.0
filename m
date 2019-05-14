Return-Path: <SRS0=nHr/=TO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5D91C04AB4
	for <linux-sgx@archiver.kernel.org>; Tue, 14 May 2019 21:27:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7484720881
	for <linux-sgx@archiver.kernel.org>; Tue, 14 May 2019 21:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557869245;
	bh=U+VL0dmjNNUjKe+d6kYcn7aIVhPL50PNNaeV/TC21FQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=lhbeb1Be0P/5FBQ90YNUqX0AQEwF1j0/FlnNib4tnWov/WLeT92/nx1OFU2XM0VYp
	 Uy3utS7t9WSb0YTWSBO33i4b69G9YlBVQYkjnswKXaRD4tFWiK6rdHlXelxlWTiUmW
	 yI08aurYsya0T+UOdHpWh04wvqhrh2ZJhxtXy86U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726195AbfENV1Y (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 May 2019 17:27:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726134AbfENV1Y (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 14 May 2019 17:27:24 -0400
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D84B21783
        for <linux-sgx@vger.kernel.org>; Tue, 14 May 2019 21:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557869243;
        bh=U+VL0dmjNNUjKe+d6kYcn7aIVhPL50PNNaeV/TC21FQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=a6H2YSuKARMMhuuyHhIETuYs0P9Hma1HC7HGG3sklOhmnxAG6Y5pCa/nRsCMTCPLj
         go2cZg8eakBmy0wHq1QWXH+RUKVJ/Ap3MANt4xZFyXhriY/1X/+DSrSHN25hZgD6pD
         I2m8bCQHMsmy+cMktNCXv0juM0A1Uyx2dlE1Fei8=
Received: by mail-wm1-f53.google.com with SMTP id 7so493380wmo.2
        for <linux-sgx@vger.kernel.org>; Tue, 14 May 2019 14:27:22 -0700 (PDT)
X-Gm-Message-State: APjAAAXQVj21OQHKvu8woMjX+FL6KB7hxwmRAB4EkEHLwrWNv4FqWmVu
        58KFSPqLyqM6g5+YzJHDfjpnlbZSI6G2Bvepa25fZQ==
X-Google-Smtp-Source: APXvYqxpB0lfEwMBY12IfeBayJqHYi+DvgTtLpUsZzB7VGY5SMRDncmL1z76a/QBfT/NRZ3R8qPWx+Ybaxb3yYRUAvw=
X-Received: by 2002:a1c:eb18:: with SMTP id j24mr21871063wmh.32.1557869241523;
 Tue, 14 May 2019 14:27:21 -0700 (PDT)
MIME-Version: 1.0
References: <960B34DE67B9E140824F1DCDEC400C0F4E885F9D@ORSMSX116.amr.corp.intel.com>
 <979615a8-fd03-e3fd-fbdb-65c1e51afd93@fortanix.com> <8fe520bb-30bd-f246-a3d8-c5443e47a014@intel.com>
 <358e9b36-230f-eb18-efdb-b472be8438b4@fortanix.com> <960B34DE67B9E140824F1DCDEC400C0F4E886094@ORSMSX116.amr.corp.intel.com>
 <6da269d8-7ebb-4177-b6a7-50cc5b435cf4@fortanix.com> <CALCETrWCZQwg-TUCm58DVG43=xCKRsMe1tVHrR8vdt06hf4fWA@mail.gmail.com>
 <20190513102926.GD8743@linux.intel.com> <20190514104323.GA7591@linux.intel.com>
 <CALCETrVbgTCnPo=PAq0-KoaRwt--urrPzn==quAJ8wodCpkBkw@mail.gmail.com> <20190514204527.GC1977@linux.intel.com>
In-Reply-To: <20190514204527.GC1977@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 14 May 2019 14:27:08 -0700
X-Gmail-Original-Message-ID: <CALCETrX6aL367mMJh5+Y1Seznfu-AvhPV6P7GkWF4Dhu0GV8cw@mail.gmail.com>
Message-ID: <CALCETrX6aL367mMJh5+Y1Seznfu-AvhPV6P7GkWF4Dhu0GV8cw@mail.gmail.com>
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
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
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, May 14, 2019 at 1:45 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, May 14, 2019 at 08:13:36AM -0700, Andy Lutomirski wrote:
> > On Tue, May 14, 2019 at 3:43 AM Jarkko Sakkinen
> > <jarkko.sakkinen@linux.intel.com> wrote:
> > >
> > > On Mon, May 13, 2019 at 01:29:26PM +0300, Jarkko Sakkinen wrote:
> > > > I did study through SDK's file format and realized that it does not
> > > > does make sense after all to embed one.
> > > >
> > > > To implement it properly you would probably need a new syscall (lets say
> > > > sgx_load_enclave) and also that enclaves are not just executables
> > > > binaries. It is hard to find a generic format for them as applications
> > > > range from simply protecting part of an application to running a
> > > > containter inside enclave.
> > >
> > > I'm still puzzling what kind of changes you were discussing considering
> > > SGX_IOC_ENCLAVE_ADD_PAGE.
> >
> > I think it's as simple as requiring that, if SECINFO.X is set, then
> > the src pointer points to the appropriate number of bytes of
> > executable memory.  (Unless there's some way for an enclave to change
> > SECINFO after the fact -- is there?)
>
> Nit: SECINFO is just the struct passed to EADD, I think what you're really
> asking is "can the EPCM permissions be changed after the fact".
>
> And the answer is, yes.
>
> On SGX2 hardware, the enclave can extend the EPCM permissions at runtime
> via ENCLU[EMODPE], e.g. to make a page writable.
>
> Hardware also doesn't prevent doing EADD to the same virtual address
> multiple times, e.g. an enclave could EADD a RX page, and then EADD a
> RW page at the same virtual address with different data.  The second EADD
> will affect MRENCLAVE, but so long as it's accounted for by the enclave's
> signer, it's "legal".  SGX_IOC_ENCLAVE_ADD_PAGE *does* prevent adding the
> "same" page to an enclave multiple times, so effectively this scenario is
> blocked by the current implementation, but it's more of a side effect (of
> a sane implementation) as opposed to deliberately preventing shenanigans.
>
> Regarding EMODPE, the kernel doesn't rely on EPCM permissions in any way
> shape or form (the EPCM permissions are purely to protect the enclave
> from the kernel), e.g. adding +X to a page in the EPCM doesn't magically
> change the kernel's page tables and attempting to execute from the page
> will still generate a (non-SGX) #PF.
>
> So rather than check SECINFO.X, I think we'd want to have EADD check that
> the permissions in SECINFO are a subset of the VMA's perms (IIUC, this is
> essentially what Cedric proposed).  That would prevent using EMODPE to
> gain executable permissions, and would explicitly deny the scenario of a
> double EADD to load non-executable data into an executable page.

Let me make sure I'm understanding this correctly: when an enclave
tries to execute code, it only works if *both* the EPCM and the page
tables grant the access, right?  This seems to be that 37.3 is trying
to say.  So we should probably just ignore SECINFO for these purposes.

But thinking this all through, it's a bit more complicated than any of
this.  Looking at the SELinux code for inspiration, there are quite a
few paths, but they boil down to two cases: EXECUTE is the right to
map an unmodified file executably, and EXECMOD/EXECMEM (the
distinction seems mostly irrelevant) is the right to create (via mmap
or mprotect) a modified anonymous file mapping or a non-file-backed
mapping that is executable.  So, if we do nothing, then mapping an
enclave with execute permission will require either EXECUTE on the
enclave inode or EXECMOD/EXECMEM, depending on exactly how this gets
set up.

So all is well, sort of.  The problem is that I expect there will be
people who want enclaves to work in a process that does not have these
rights.  To make this work, we probably need do some surgery on
SELinux.  ISTM the act of copying (via the EADD ioctl) data from a
PROT_EXEC mapping to an enclave should not be construed as "modifying"
the enclave for SELinux purposes.  Actually doing this could be
awkward, since the same inode will have executable parts and
non-executable parts, and SELinux can't really tell the difference.

Maybe the enclave should track a bitmap of which pages have ever been
either mapped for write or EADDed with a *source* that wasn't
PROT_EXEC.  And then SELinux could learn to allow those pages (and
only those pages) to be mapped executably without EXECUTE or EXECMOD
or whatever permission.

Does this seem at all reasonable?

I suppose it's not the end of the world if the initially merged
version doesn't do this, as long as there's some reasonable path to
adding a mechanism like this when there's demand for it.
