Return-Path: <SRS0=1Eyi=O5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7190BC43387
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Dec 2018 13:20:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46333217D8
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Dec 2018 13:20:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732425AbeLTNUF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Dec 2018 08:20:05 -0500
Received: from mga05.intel.com ([192.55.52.43]:48383 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732391AbeLTNUE (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Dec 2018 08:20:04 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2018 05:20:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,377,1539673200"; 
   d="scan'208";a="285273460"
Received: from unknown (HELO localhost) ([10.249.254.232])
  by orsmga005.jf.intel.com with ESMTP; 20 Dec 2018 05:19:57 -0800
Date:   Thu, 20 Dec 2018 15:19:55 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: x86/sgx: uapi change proposal
Message-ID: <20181220131955.GB4848@linux.intel.com>
References: <20181214215729.4221-1-sean.j.christopherson@intel.com>
 <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com>
 <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com>
 <20181219091148.GA5121@linux.intel.com>
 <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com>
 <20181219144515.GA30909@linux.intel.com>
 <CALCETrW_8LnitFamYUU7POHFOJFxLO7ESFUdS=aeG_SOvHVPkw@mail.gmail.com>
 <20181220103204.GB26410@linux.intel.com>
 <20181220131213.GA4848@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181220131213.GA4848@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Dec 20, 2018 at 03:12:13PM +0200, Jarkko Sakkinen wrote:
> On Thu, Dec 20, 2018 at 12:32:04PM +0200, Jarkko Sakkinen wrote:
> > On Wed, Dec 19, 2018 at 06:58:48PM -0800, Andy Lutomirski wrote:
> > > Can one of you explain why SGX_ENCLAVE_CREATE is better than just
> > > opening a new instance of /dev/sgx for each encalve?
> > 
> > I think that fits better to the SCM_RIGHTS scenario i.e. you could send
> > the enclav to a process that does not have necessarily have rights to
> > /dev/sgx. Gives more robust environment to configure SGX.
> 
> My only open for the implementation is where to swap? If it is a VMA,
> whose VMA?
> 
> Please share your views here. Not a blocker for me to work on the
> implementation, though. I'll use a private shmem file up until there
> is a better option.
> 
> This ioctl API discussion is kind of meaningless for me ATM because it
> does not have that much effect to the internals even if it wouldn't be
> perfect in v19. Very trival to change.

Oops, and after sending I realized that I started this thread asking
comments about the API (I think I mentioned swapping though too) :-) The
feedback has been valuable and I gained the required understanding about
enclave_fd but I think that now the things have been saturated to minor
details.

Appreciate all the feedback so far. Sorry for a bit harsh statement.

/Jarkko
