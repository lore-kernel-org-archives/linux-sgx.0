Return-Path: <SRS0=QGFU=VE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69705C48BDE
	for <linux-sgx@archiver.kernel.org>; Sun,  7 Jul 2019 19:08:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E82720673
	for <linux-sgx@archiver.kernel.org>; Sun,  7 Jul 2019 19:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727371AbfGGTIK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 7 Jul 2019 15:08:10 -0400
Received: from mga12.intel.com ([192.55.52.136]:26194 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbfGGTIK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 7 Jul 2019 15:08:10 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jul 2019 12:08:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,463,1557212400"; 
   d="scan'208";a="173085605"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Jul 2019 12:08:09 -0700
Date:   Sun, 7 Jul 2019 12:08:09 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC PATCH v3 04/12] x86/sgx: Require userspace to define
 enclave pages' protection bits
Message-ID: <20190707190809.GE19593@linux.intel.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
 <20190617222438.2080-5-sean.j.christopherson@intel.com>
 <dc3d59c2783ea81d85d4d447bd1a4a2d5fe51421.camel@linux.intel.com>
 <20190619152018.GC1203@linux.intel.com>
 <20190620221702.GE20474@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620221702.GE20474@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jun 21, 2019 at 01:17:02AM +0300, Jarkko Sakkinen wrote:
> On Wed, Jun 19, 2019 at 08:20:18AM -0700, Sean Christopherson wrote:
> > On Wed, Jun 19, 2019 at 05:43:11PM +0300, Jarkko Sakkinen wrote:
> > > On Mon, 2019-06-17 at 15:24 -0700, Sean Christopherson wrote:
> > > > +	__u32	flags;
> > > 
> > > This should be changed to secinfo_flags_mask containing a mask of the
> > > allowed bits for the secinfo flags because of two obvious reasons:
> > > 
> > > 1. Protection flags are used mainly with syscalls and contain also other
> > >    things than just the permissions that do not apply in this context.
> > > 2. Having a mask for all secinfo flags is more future proof.
> > > 
> > > With the protection flags you end up reserving bits forever for things
> > > that we will never have any use for (e.g. PROT_SEM).
> > > 
> > > Looking the change you convert 'flags' (wondering why it isn't called
> > > 'prot') to VM flags, which means that you essentially gain absolutely
> > > nothing and loose some potential versatility as a side-effect by doing
> > > that.
> > 
> > Ah, I see where you're coming from.  My intent was that supported flags
> > would be SGX specific, not generic PROT_* flags.  I.e. bits 2:0 are used
> > for PROT_{READ,WRITE,EXEC}, bit 7 can be used for SGX_ZERO_PAGE, etc...
> > 
> > I have two objections to 'secinfo_flags_mask':
> > 
> >   - A full SECINFO mask is problematic for literally every other bit/field
> >     currently defined in SECINFO.FLAGS, e.g. masking PAGE_TYPE, PENDING
> >     and MODIFIED adds no value that I can think of, but would require the
> >     kernel do to weird things like reject page types and EMODPR requests
> >     (due to their PENDING/MODIFIED interaction).
> 
> You're probably right that in practice it would hard to do much with
> EMODT.
> 
> >   - The kernel doesn't actually restrict SECINFO based on the param, it's
> >     restricting VM_MAY* flags in the vmas.  'secinfo_flags_mask' implies
> >     the kernel is somehow masking SECINFO.
> >
> > What about something like this?
> > 
> > /**
> >  * struct sgx_enclave_add_page - parameter structure for the
> >  *                               %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
> >  * @addr:	address within the ELRANGE
> >  * @src:	address for the page data
> >  * @secinfo:	address for the SECINFO data
> >  * @mrmask:	bitmask for the measured 256 byte chunks
> >  * @prot:	maximal PROT_{READ,WRITE,EXEC} permissions for the page
> >  */
> > struct sgx_enclave_add_page {
> > 	__u64		addr;
> > 	__u64		src;
> > 	__u64		secinfo;
> > 	__u16		mrmask;
> > 	__u8		prot;
> > 	__u8		pad;
> > 	__u64[2]	reserved;
> > };
> 
> LGTM but why it isn't like:
> 
> __u16 mrmask;
> __u8 prot;
> __u8 reserved[5];

Because math is hard :-)  Though I think we'd want

  __u16 mrmask
  __u8  prot
  __u8  pad[5];

with an optional

  __u64 reserved[?];

"pad" can be ignored, e.g. doesn't need to be explicitly zeroed by
userspace, whereas "reserved" requires explicit zeroing and probably an
associated kernel check.
