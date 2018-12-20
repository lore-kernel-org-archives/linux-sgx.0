Return-Path: <SRS0=1Eyi=O5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1056DC43387
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Dec 2018 12:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDBD32176F
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Dec 2018 12:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732266AbeLTMtq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Dec 2018 07:49:46 -0500
Received: from mga06.intel.com ([134.134.136.31]:29133 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728966AbeLTMtq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Dec 2018 07:49:46 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2018 04:49:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,377,1539673200"; 
   d="scan'208";a="129450342"
Received: from unknown (HELO localhost) ([10.249.254.232])
  by fmsmga004.fm.intel.com with ESMTP; 20 Dec 2018 04:49:38 -0800
Date:   Thu, 20 Dec 2018 14:49:37 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     jethro@fortanix.com, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        sean.j.christopherson@intel.com, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Josh Triplett <josh@joshtriplett.org>,
        haitao.huang@linux.intel.com, greg@enjellic.com
Subject: Re: x86/sgx: uapi change proposal
Message-ID: <20181220124937.GA3753@linux.intel.com>
References: <20181214215729.4221-1-sean.j.christopherson@intel.com>
 <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com>
 <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com>
 <CAK8P3a3QatXPYgDzZkUpxwHh5HJw5-XWA6VoyxW6Y9UAnzS=tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a3QatXPYgDzZkUpxwHh5HJw5-XWA6VoyxW6Y9UAnzS=tQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Dec 20, 2018 at 01:08:46PM +0100, Arnd Bergmann wrote:
> On Wed, Dec 19, 2018 at 10:26 AM Jethro Beekman <jethro@fortanix.com> wrote:
> >
> > On 2018-12-19 13:28, Jarkko Sakkinen wrote:
> > > /**
> > >  * struct sgx_enclave_add_page - parameter structure for the
> > >  *                               %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
> > >  * @eclave_fd:        file handle to the enclave address space
> > >  * @src:      address for the page data
> > >  * @secinfo:  address for the SECINFO data
> > >  * @mrmask:   bitmask for the measured 256 byte chunks
> > >  */
> > > struct sgx_enclave_add_page {
> > >       __u64   enclave_fd;
> > >       __u64   src;
> > >       __u64   secinfo;
> > >       __u16   mrmask;
> > > } __attribute__((__packed__));
> >
> > Wouldn't you just pass enclave_fd as the ioctl fd parameter?
> >
> > How to specify the address of the page that is being added?
> 
> One more comment about the structure: I would generally recommend
> against packing structures like this. Instead just extend the mrmask
> member to 64 bits as well.

Can do. Thanks for the remark.

/Jarkko
