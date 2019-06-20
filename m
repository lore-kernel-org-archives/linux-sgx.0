Return-Path: <SRS0=1VuV=UT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3BA8C43613
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Jun 2019 22:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C06372070B
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Jun 2019 22:17:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfFTWRH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Jun 2019 18:17:07 -0400
Received: from mga14.intel.com ([192.55.52.115]:57399 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbfFTWRH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Jun 2019 18:17:07 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 15:17:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,398,1557212400"; 
   d="scan'208";a="358683766"
Received: from mudigirx-mobl1.gar.corp.intel.com (HELO localhost) ([10.252.61.12])
  by fmsmga005.fm.intel.com with ESMTP; 20 Jun 2019 15:17:03 -0700
Date:   Fri, 21 Jun 2019 01:17:02 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC PATCH v3 04/12] x86/sgx: Require userspace to define
 enclave pages' protection bits
Message-ID: <20190620221702.GE20474@linux.intel.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
 <20190617222438.2080-5-sean.j.christopherson@intel.com>
 <dc3d59c2783ea81d85d4d447bd1a4a2d5fe51421.camel@linux.intel.com>
 <20190619152018.GC1203@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619152018.GC1203@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 19, 2019 at 08:20:18AM -0700, Sean Christopherson wrote:
> On Wed, Jun 19, 2019 at 05:43:11PM +0300, Jarkko Sakkinen wrote:
> > On Mon, 2019-06-17 at 15:24 -0700, Sean Christopherson wrote:
> > > +	__u32	flags;
> > 
> > This should be changed to secinfo_flags_mask containing a mask of the
> > allowed bits for the secinfo flags because of two obvious reasons:
> > 
> > 1. Protection flags are used mainly with syscalls and contain also other
> >    things than just the permissions that do not apply in this context.
> > 2. Having a mask for all secinfo flags is more future proof.
> > 
> > With the protection flags you end up reserving bits forever for things
> > that we will never have any use for (e.g. PROT_SEM).
> > 
> > Looking the change you convert 'flags' (wondering why it isn't called
> > 'prot') to VM flags, which means that you essentially gain absolutely
> > nothing and loose some potential versatility as a side-effect by doing
> > that.
> 
> Ah, I see where you're coming from.  My intent was that supported flags
> would be SGX specific, not generic PROT_* flags.  I.e. bits 2:0 are used
> for PROT_{READ,WRITE,EXEC}, bit 7 can be used for SGX_ZERO_PAGE, etc...
> 
> I have two objections to 'secinfo_flags_mask':
> 
>   - A full SECINFO mask is problematic for literally every other bit/field
>     currently defined in SECINFO.FLAGS, e.g. masking PAGE_TYPE, PENDING
>     and MODIFIED adds no value that I can think of, but would require the
>     kernel do to weird things like reject page types and EMODPR requests
>     (due to their PENDING/MODIFIED interaction).

You're probably right that in practice it would hard to do much with
EMODT.

>   - The kernel doesn't actually restrict SECINFO based on the param, it's
>     restricting VM_MAY* flags in the vmas.  'secinfo_flags_mask' implies
>     the kernel is somehow masking SECINFO.
>
> What about something like this?
> 
> /**
>  * struct sgx_enclave_add_page - parameter structure for the
>  *                               %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
>  * @addr:	address within the ELRANGE
>  * @src:	address for the page data
>  * @secinfo:	address for the SECINFO data
>  * @mrmask:	bitmask for the measured 256 byte chunks
>  * @prot:	maximal PROT_{READ,WRITE,EXEC} permissions for the page
>  */
> struct sgx_enclave_add_page {
> 	__u64		addr;
> 	__u64		src;
> 	__u64		secinfo;
> 	__u16		mrmask;
> 	__u8		prot;
> 	__u8		pad;
> 	__u64[2]	reserved;
> };

LGTM but why it isn't like:

__u16 mrmask;
__u8 prot;
__u8 reserved[5];

/Jarkko
