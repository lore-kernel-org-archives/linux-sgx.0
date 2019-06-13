Return-Path: <SRS0=rpH8=UM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C054CC31E45
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 17:15:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A30332053B
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 17:15:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393585AbfFMRO5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Jun 2019 13:14:57 -0400
Received: from mga14.intel.com ([192.55.52.115]:2618 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393579AbfFMROz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 13 Jun 2019 13:14:55 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 10:14:55 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga006.jf.intel.com with ESMTP; 13 Jun 2019 10:14:52 -0700
Date:   Thu, 13 Jun 2019 10:14:51 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
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
Subject: Re: [RFC PATCH 2/9] x86/sgx: Do not naturally align MAP_FIXED address
Message-ID: <20190613171451.GD5850@linux.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-3-sean.j.christopherson@intel.com>
 <20190604114951.GC30594@linux.intel.com>
 <CALCETrVe0jhAWAFmx+NFEjJcijSJv2LDVC7cUXi0w99kNKjh_g@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654EDBDE@ORSMSX116.amr.corp.intel.com>
 <20190605151653.GK11331@linux.intel.com>
 <5A85C1D7-A159-437E-B42A-3F4254E07305@amacapital.net>
 <20190606153710.GB25112@linux.intel.com>
 <20190613134800.GA12791@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F65503A93@ORSMSX116.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F65503A93@ORSMSX116.amr.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jun 13, 2019 at 09:47:06AM -0700, Xing, Cedric wrote:
> > From: Jarkko Sakkinen [mailto:jarkko.sakkinen@linux.intel.com]
> > Sent: Thursday, June 13, 2019 6:48 AM
> > 
> > On Thu, Jun 06, 2019 at 06:37:10PM +0300, Jarkko Sakkinen wrote:
> > > On Wed, Jun 05, 2019 at 01:14:04PM -0700, Andy Lutomirski wrote:
> > > >
> > > >
> > > > > On Jun 5, 2019, at 8:17 AM, Jarkko Sakkinen
> > <jarkko.sakkinen@linux.intel.com> wrote:
> > > > >
> > > > >> On Tue, Jun 04, 2019 at 10:10:22PM +0000, Xing, Cedric wrote:
> > > > >> A bit off topic here. This mmap()/mprotect() discussion reminds
> > > > >> me a question (guess for Jarkko): Now that
> > > > >> vma->vm_file->private_data keeps a pointer to the enclave, why do
> > we store it again in vma->vm_private?
> > > > >> It isn't a big deal but non-NULL vm_private does prevent
> > > > >> mprotect() from merging adjacent VMAs.
> > > > >
> > > > > Same semantics as with a regular mmap i.e. you can close the file
> > > > > and still use the mapping.
> > > > >
> > > > >
> > > >
> > > > The file should be properly refcounted — vm_file should not go away
> > while it’s mapped.
> > 
> > mm already takes care of that so vm_file does not go away. Still we need
> > an internal refcount for enclaves to synchronize with the swapper. In
> > summary nothing needs to be done.
> 
> I don't get this. The swapper takes a read lock on mm->mmap_sem, which locks
> the vma, which in turn reference counts vma->vm_file. Why is the internal
> refcount still needed? 

mmap_sem is only held when reclaim is touching PTEs, e.g. to test/clear
its accessed bit and to zap the PTE.  The liveliness of the enclave needs
to be guaranteed for the entire duration of reclaim, e.g. we can't have
the enclave disappearing when we go to do EWB.  It's also worth nothing
that a single reclaim may operate on more than one mmap_sem, as enclaves
can be shared across processes (mm_structs).
