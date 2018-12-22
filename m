Return-Path: <SRS0=8byu=O7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA32C43387
	for <linux-sgx@archiver.kernel.org>; Sat, 22 Dec 2018 17:38:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7881821A4E
	for <linux-sgx@archiver.kernel.org>; Sat, 22 Dec 2018 17:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391545AbeLVRis (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 22 Dec 2018 12:38:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:5578 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389447AbeLVRis (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 22 Dec 2018 12:38:48 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Dec 2018 00:16:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,383,1539673200"; 
   d="scan'208";a="305910739"
Received: from ncanderx-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.238])
  by fmsmga005.fm.intel.com with ESMTP; 22 Dec 2018 00:16:51 -0800
Date:   Sat, 22 Dec 2018 10:16:49 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
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
Message-ID: <20181222081649.GB8895@linux.intel.com>
References: <20181214215729.4221-1-sean.j.christopherson@intel.com>
 <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com>
 <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com>
 <20181219091148.GA5121@linux.intel.com>
 <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com>
 <20181219144515.GA30909@linux.intel.com>
 <CALCETrW_8LnitFamYUU7POHFOJFxLO7ESFUdS=aeG_SOvHVPkw@mail.gmail.com>
 <20181220103204.GB26410@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181220103204.GB26410@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Dec 20, 2018 at 12:32:04PM +0200, Jarkko Sakkinen wrote:
> On Wed, Dec 19, 2018 at 06:58:48PM -0800, Andy Lutomirski wrote:
> > Can one of you explain why SGX_ENCLAVE_CREATE is better than just
> > opening a new instance of /dev/sgx for each encalve?
> 
> I think that fits better to the SCM_RIGHTS scenario i.e. you could send
> the enclav to a process that does not have necessarily have rights to
> /dev/sgx. Gives more robust environment to configure SGX.

Sean, is this why you wanted enclave fd and anon inode and not just use
the address space of /dev/sgx? Just taking notes of all observations.
I'm not sure what your rationale was (maybe it was somewhere). This was
something I made up, and this one is wrong deduction. You can easily
get the same benefit with /dev/sgx associated fd representing the
enclave.

This all means that for v19 I'm going without enclave fd involved with
fd to /dev/sgx representing the enclave. No anon inodes will be
involved.

/Jarkko
