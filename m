Return-Path: <SRS0=xedp=5E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA6AC4332D
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 17:17:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 754172070A
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 17:17:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgCSRRR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Mar 2020 13:17:17 -0400
Received: from wind.enjellic.com ([76.10.64.91]:60660 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727556AbgCSRRQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 19 Mar 2020 13:17:16 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 02JHGiFm023297;
        Thu, 19 Mar 2020 12:16:44 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 02JHGhMO023296;
        Thu, 19 Mar 2020 12:16:43 -0500
Date:   Thu, 19 Mar 2020 12:16:43 -0500
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
Subject: Re: [PATCH v28 00/22] Intel SGX foundations
Message-ID: <20200319171643.GA22995@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com> <8832f446-fbf1-f480-8cfa-848cc5101cb5@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8832f446-fbf1-f480-8cfa-848cc5101cb5@linux.microsoft.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Thu, 19 Mar 2020 12:16:44 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 17, 2020 at 09:00:15AM -0700, Jordan Hand wrote:

Hi, I hope the week is going well for everyone.

> I tested with the Open Enclave SDK test suite (~200 test and sample
> enclaves), no issues. Used Intel PSW version 2.8.
>
> Tested-by: Jordan Hand <jorhand@linux.microsoft.com>

Which effectively translates into a second test of the Intel PSW,
since it appears from Haitao's comments they are unit testing against
the new driver.

Unless of course you wired up the OpenEnclave infrastructure to use
the new VDSO and exception handling, as that would be a significant
test, is that the case?

Getting a real live enclave loaded and initialized in memory is
essentially a contract with the enclave ELF parser and metadata
interpreter that the runtime implements.  There is nothing subtle
about whether or not that is working correctly.  The acid test after
that is the enclave entry and exit handling which is ultimately a
function of the exception handling.

> Thanks,
> Jordan

Have a good remainder of the week.

Dr. Greg

As always,
Dr. Greg Wettstein, Ph.D, Worker      SGX secured infrastructure and
Enjellic Systems Development, LLC     autonomously self-defensive
4206 N. 19th Ave.                     platforms.
Fargo, ND  58102
PH: 701-281-1686                      EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"God made man, the appendix was the result of a committee."
                                -- Dr. G.W. Wettstein
                                   Guerrilla Tactics for Corporate Survival
