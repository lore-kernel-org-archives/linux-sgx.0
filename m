Return-Path: <SRS0=m9nj=TQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2495BC04AB4
	for <linux-sgx@archiver.kernel.org>; Thu, 16 May 2019 07:02:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA43D20862
	for <linux-sgx@archiver.kernel.org>; Thu, 16 May 2019 07:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbfEPHCt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 16 May 2019 03:02:49 -0400
Received: from mga07.intel.com ([134.134.136.100]:16965 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbfEPHCt (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 16 May 2019 03:02:49 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 May 2019 00:02:47 -0700
X-ExtLoop1: 1
Received: from odonnabh-mobl.ger.corp.intel.com (HELO localhost) ([10.252.32.47])
  by fmsmga007.fm.intel.com with ESMTP; 16 May 2019 00:02:38 -0700
Date:   Thu, 16 May 2019 10:02:36 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
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
Message-ID: <20190516070236.GA5589@linux.intel.com>
References: <CALCETrWCZQwg-TUCm58DVG43=xCKRsMe1tVHrR8vdt06hf4fWA@mail.gmail.com>
 <20190513102926.GD8743@linux.intel.com>
 <20190514104323.GA7591@linux.intel.com>
 <CALCETrVbgTCnPo=PAq0-KoaRwt--urrPzn==quAJ8wodCpkBkw@mail.gmail.com>
 <20190514204527.GC1977@linux.intel.com>
 <20190515103531.GB10917@linux.intel.com>
 <20190515110005.GA14718@linux.intel.com>
 <B1DF6DCD-C37D-4C87-AF32-F31785184482@amacapital.net>
 <20190516050705.GB6388@linux.intel.com>
 <20190516065103.GA4642@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190516065103.GA4642@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, May 16, 2019 at 09:51:03AM +0300, Jarkko Sakkinen wrote:
> On Thu, May 16, 2019 at 08:07:05AM +0300, Jarkko Sakkinen wrote:
> > On Wed, May 15, 2019 at 07:27:02AM -0700, Andy Lutomirski wrote:
> > > 
> > > > On May 15, 2019, at 4:00 AM, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:
> > > > 
> > > >> On Wed, May 15, 2019 at 01:35:31PM +0300, Jarkko Sakkinen wrote:
> > > >> This brings me to an open question in Andy's model: lets say that we
> > > >> change the source for SIGSTRUCT from memory address to fd. How can the
> > > >> policy prevent the use not creating a file containing a SIGSTRUCT and
> > > >> passing fd of that to the EINIT ioctl?
> > > > 
> > > 
> > > The policy will presumably check the label on the file that the fd points to.
> > 
> > Right (checked SELinux documentation).
> > 
> > Got one idea from this. Right now creation and initialization does not
> > require any VMAs to be created (since v20). Requiring to map a VMA for
> > copying the data would bring in my opinion a glitch to this model that
> > we have done effort to build up.
> > 
> > What if we similarly change EADD ioctl in a way that it'd take an fd
> > and an offset? This way we can enforce policy to the source where the
> > enclave data is loaded from. On the other hand, loading SIGSTRUCT from
> > fd enforces a legit structure for the enclave.
> > 
> > This would still allow to construct enclaves in VMA independent way.
> 
> The API would turn into this:
> 
> /**
>  * struct sgx_enclave_add_page - parameter structure for the
>  *                               %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
>  * @fd:		file containing the page data
>  * @offset:	offset in the file containing the page data
>  * @secinfo:	address for the SECINFO data
>  * @mrmask:	bitmask for the measured 256 byte chunks
>  */
> struct sgx_enclave_add_page {
> 	__u64	fd;
> 	__u64	offset;
> 	__u64	secinfo;
> 	__u16	mrmask;
> } __attribute__((__packed__));
> 
> 
> /**
>  * struct sgx_enclave_init - parameter structure for the
>  *                           %SGX_IOC_ENCLAVE_INIT ioctl
>  * @fd:		file containing the sigstruct
>  * @offset:	offset in the file containing the sigstruct
>  */
> struct sgx_enclave_init {
> 	__u64	fd;
> 	__u64	offset;
> };

The change to EADD/EINIT ioctl's would be simply fget/kernel_read/fput
sequence replacing copy_from_user().

/Jarkko
