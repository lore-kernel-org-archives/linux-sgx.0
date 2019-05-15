Return-Path: <SRS0=97/O=TP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEED1C04AB4
	for <linux-sgx@archiver.kernel.org>; Wed, 15 May 2019 01:30:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A522020879
	for <linux-sgx@archiver.kernel.org>; Wed, 15 May 2019 01:30:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfEOBac (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 May 2019 21:30:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:13129 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbfEOBac (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 14 May 2019 21:30:32 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 May 2019 18:30:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,470,1549958400"; 
   d="scan'208";a="171798342"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga002.fm.intel.com with ESMTP; 14 May 2019 18:30:31 -0700
Date:   Tue, 14 May 2019 18:30:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
Message-ID: <20190515013031.GF1977@linux.intel.com>
References: <8fe520bb-30bd-f246-a3d8-c5443e47a014@intel.com>
 <358e9b36-230f-eb18-efdb-b472be8438b4@fortanix.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E886094@ORSMSX116.amr.corp.intel.com>
 <6da269d8-7ebb-4177-b6a7-50cc5b435cf4@fortanix.com>
 <CALCETrWCZQwg-TUCm58DVG43=xCKRsMe1tVHrR8vdt06hf4fWA@mail.gmail.com>
 <20190513102926.GD8743@linux.intel.com>
 <20190514104323.GA7591@linux.intel.com>
 <CALCETrVbgTCnPo=PAq0-KoaRwt--urrPzn==quAJ8wodCpkBkw@mail.gmail.com>
 <20190514204527.GC1977@linux.intel.com>
 <CALCETrX6aL367mMJh5+Y1Seznfu-AvhPV6P7GkWF4Dhu0GV8cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrX6aL367mMJh5+Y1Seznfu-AvhPV6P7GkWF4Dhu0GV8cw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, May 14, 2019 at 02:27:08PM -0700, Andy Lutomirski wrote:
> On Tue, May 14, 2019 at 1:45 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Tue, May 14, 2019 at 08:13:36AM -0700, Andy Lutomirski wrote:
> > > On Tue, May 14, 2019 at 3:43 AM Jarkko Sakkinen
> > > <jarkko.sakkinen@linux.intel.com> wrote:
> > > >
> > > > On Mon, May 13, 2019 at 01:29:26PM +0300, Jarkko Sakkinen wrote:
> > > > > I did study through SDK's file format and realized that it does not
> > > > > does make sense after all to embed one.
> > > > >
> > > > > To implement it properly you would probably need a new syscall (lets say
> > > > > sgx_load_enclave) and also that enclaves are not just executables
> > > > > binaries. It is hard to find a generic format for them as applications
> > > > > range from simply protecting part of an application to running a
> > > > > containter inside enclave.
> > > >
> > > > I'm still puzzling what kind of changes you were discussing considering
> > > > SGX_IOC_ENCLAVE_ADD_PAGE.
> > >
> > > I think it's as simple as requiring that, if SECINFO.X is set, then
> > > the src pointer points to the appropriate number of bytes of
> > > executable memory.  (Unless there's some way for an enclave to change
> > > SECINFO after the fact -- is there?)
> >
> > Nit: SECINFO is just the struct passed to EADD, I think what you're really
> > asking is "can the EPCM permissions be changed after the fact".
> >
> > And the answer is, yes.
> >
> > On SGX2 hardware, the enclave can extend the EPCM permissions at runtime
> > via ENCLU[EMODPE], e.g. to make a page writable.
> >
> > Hardware also doesn't prevent doing EADD to the same virtual address
> > multiple times, e.g. an enclave could EADD a RX page, and then EADD a
> > RW page at the same virtual address with different data.  The second EADD
> > will affect MRENCLAVE, but so long as it's accounted for by the enclave's
> > signer, it's "legal".  SGX_IOC_ENCLAVE_ADD_PAGE *does* prevent adding the
> > "same" page to an enclave multiple times, so effectively this scenario is
> > blocked by the current implementation, but it's more of a side effect (of
> > a sane implementation) as opposed to deliberately preventing shenanigans.
> >
> > Regarding EMODPE, the kernel doesn't rely on EPCM permissions in any way
> > shape or form (the EPCM permissions are purely to protect the enclave
> > from the kernel), e.g. adding +X to a page in the EPCM doesn't magically
> > change the kernel's page tables and attempting to execute from the page
> > will still generate a (non-SGX) #PF.
> >
> > So rather than check SECINFO.X, I think we'd want to have EADD check that
> > the permissions in SECINFO are a subset of the VMA's perms (IIUC, this is
> > essentially what Cedric proposed).  That would prevent using EMODPE to
> > gain executable permissions, and would explicitly deny the scenario of a
> > double EADD to load non-executable data into an executable page.
> 
> Let me make sure I'm understanding this correctly: when an enclave
> tries to execute code, it only works if *both* the EPCM and the page
> tables grant the access, right?  This seems to be that 37.3 is trying
> to say.  So we should probably just ignore SECINFO for these purposes.

Yep.  More specifically, the EPCM is consulted if and only if the access
is allowed by the page tables.

I agree on ignoring SECINFO.

> But thinking this all through, it's a bit more complicated than any of
> this.  Looking at the SELinux code for inspiration, there are quite a
> few paths, but they boil down to two cases: EXECUTE is the right to
> map an unmodified file executably, and EXECMOD/EXECMEM (the
> distinction seems mostly irrelevant) is the right to create (via mmap
> or mprotect) a modified anonymous file mapping or a non-file-backed
> mapping that is executable.  So, if we do nothing, then mapping an
> enclave with execute permission will require either EXECUTE on the
> enclave inode or EXECMOD/EXECMEM, depending on exactly how this gets
> set up.

If we do literally nothing, then I'm pretty sure mapping an enclave will
require PROCESS__EXECMEM.  The mmap() for the actual enclave is done
using an anon inode, e.g. from /dev/sgx/enclave.  Anon inodes are marked
private, which means inode_has_perm() will always return "success".  The
only effective check is in file_map_prot_check() when default_noexec is
true, in which case requesting PROT_EXEC on private inodes requires
PROCESS__EXECMEM.

> So all is well, sort of.  The problem is that I expect there will be
> people who want enclaves to work in a process that does not have these
> rights.  To make this work, we probably need do some surgery on
> SELinux.  ISTM the act of copying (via the EADD ioctl) data from a
> PROT_EXEC mapping to an enclave should not be construed as "modifying"
> the enclave for SELinux purposes.  Actually doing this could be
> awkward, since the same inode will have executable parts and
> non-executable parts, and SELinux can't really tell the difference.

Rather the do surgery on SELinux, why not go with Cedric's original
proposal and propagate the permissions from the source VMA to the EPC
VMA?  The enclave mmap() from userspace could then be done with RO
permissions so as to not run afoul of LSMs.  Adding PROT_EXEC after
EADD would require PROCESS__EXECMEM, but that's in line with mprotect()
on regular memory.  It also punts the EMODPE hiccup to userspace, e.g.
any enclave that wants to do fancy things with PROT_EXEC needs
PROCESS__EXECMEM.

The only downside I see is that SGX would be doing a bit of magic with
enclave VMAs.

> Maybe the enclave should track a bitmap of which pages have ever been
> either mapped for write or EADDed with a *source* that wasn't
> PROT_EXEC.  And then SELinux could learn to allow those pages (and
> only those pages) to be mapped executably without EXECUTE or EXECMOD
> or whatever permission.
> 
> Does this seem at all reasonable?

No?  I don't understand why you want to special case enclaves from an
LSM perspective.  Enforcing LSM policies on the source provides the
same security for enclaves as it does for normal code, no more, no less.

> I suppose it's not the end of the world if the initially merged
> version doesn't do this, as long as there's some reasonable path to
> adding a mechanism like this when there's demand for it.
