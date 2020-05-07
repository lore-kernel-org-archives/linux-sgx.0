Return-Path: <SRS0=jkgx=6V=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D229CC38A2A
	for <linux-sgx@archiver.kernel.org>; Thu,  7 May 2020 18:07:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A92CE2145D
	for <linux-sgx@archiver.kernel.org>; Thu,  7 May 2020 18:07:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgEGSH3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 7 May 2020 14:07:29 -0400
Received: from wind.enjellic.com ([76.10.64.91]:43302 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbgEGSH3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 7 May 2020 14:07:29 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 047I6sWO017840;
        Thu, 7 May 2020 13:06:54 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 047I6sTR017839;
        Thu, 7 May 2020 13:06:54 -0500
Date:   Thu, 7 May 2020 13:06:54 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Jordan Hand <jorhand@linux.microsoft.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
Message-ID: <20200507180654.GA17632@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com> <e50f4c00-12e6-19e6-ead3-f180074bceea@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e50f4c00-12e6-19e6-ead3-f180074bceea@linux.microsoft.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Thu, 07 May 2020 13:06:54 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, May 06, 2020 at 09:39:55AM -0700, Jordan Hand wrote:

Good afternoon, I hope the week is going well for everyone.

> On 4/21/20 2:52 PM, Jarkko Sakkinen wrote:
> > Make the vDSO callable directly from C by preserving RBX and taking leaf
> >   from RCX.

> Tested with the Open Enclave SDK on top of Intel PSW. Specifically built 
> the Intel PSW with changes to support /dev/sgx mapping[1] new in v29.
> 
> Tested-by: Jordan Hand <jorhand@linux.microsoft.com>
> 
> [1] https://github.com/intel/linux-sgx/pull/530

Did you re-wire your SDK to convert all your ECALL and exception
handling to the new VDSO architecture?

Failures in enclave loading and initialization demonstrate themselves
pretty clearly and are in the domain of the PSW being used.  If there
are going to be subtle SGX application operability issues that need to
be found they will be in the new ECALL and exception handling
mechanisms.

Have a good remainder of the day.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker      Artisans in autonomously
Enjellic Systems Development, LLC     self-defensive IOT platforms
4206 N. 19th Ave.                     and edge devices.
Fargo, ND  58102
PH: 701-281-1686                      EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Davidsen's first rule of system administration:  He learns to swim fastest
 who is thrown in the deepest water."
                                -- Bill Davidsen
