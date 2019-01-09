Return-Path: <SRS0=Hssn=PR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E9DAC43387
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Jan 2019 14:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33C092070B
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Jan 2019 14:45:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731842AbfAIOpa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Jan 2019 09:45:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:38699 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731753AbfAIOpa (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 9 Jan 2019 09:45:30 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Jan 2019 06:45:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,457,1539673200"; 
   d="scan'208";a="115420021"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.93])
  by fmsmga008.fm.intel.com with ESMTP; 09 Jan 2019 06:45:25 -0800
Date:   Wed, 9 Jan 2019 16:45:25 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
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
Message-ID: <20190109144524.GA8367@linux.intel.com>
References: <20181219091148.GA5121@linux.intel.com>
 <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com>
 <20181219144515.GA30909@linux.intel.com>
 <CALCETrW_8LnitFamYUU7POHFOJFxLO7ESFUdS=aeG_SOvHVPkw@mail.gmail.com>
 <20181220103204.GB26410@linux.intel.com>
 <20181222081649.GB8895@linux.intel.com>
 <20181222082502.GA13275@linux.intel.com>
 <20190102204752.GG7460@linux.intel.com>
 <20190103150256.GA17015@linux.intel.com>
 <20190103162634.GA8610@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190103162634.GA8610@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jan 03, 2019 at 08:26:35AM -0800, Sean Christopherson wrote:
> What I was trying to explain is that the uapi isn't for KVM, it's for
> the userspace hypervisor, e.g. Qemu.  Qemu will inform KVM of the
> resulting guest memory region so that KVM can configure its guest page
> tables accordingly, but that is done through KVM's existing memory uapi.

OK, I now I got it, apologies it took such a long time :-)

Now I see the analogy e.g. qemu creates independently VMAs and then
fuels those regions to KVM. Similarly qemu would create regions for
KVM using "/dev/sgx/mem".

For me this is perfectly fine now I understand the reasoning and neither
does make my job more difficult to implement the file based enclave
change.

Thanks for the patience with this...

/Jarkko
