Return-Path: <SRS0=4/gY=64=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6753C433E0
	for <linux-sgx@archiver.kernel.org>; Thu, 14 May 2020 19:29:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86F6E20643
	for <linux-sgx@archiver.kernel.org>; Thu, 14 May 2020 19:29:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgENT30 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 14 May 2020 15:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725965AbgENT30 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 14 May 2020 15:29:26 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4CC8C061A0C;
        Thu, 14 May 2020 12:29:25 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jZJXe-0007Td-4a; Thu, 14 May 2020 21:29:14 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 5C81B1004CE; Thu, 14 May 2020 21:29:13 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     "Dr. Greg" <greg@enjellic.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, kai.svahn@intel.com,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
In-Reply-To: <20200514162054.GE9266@zn.tnic>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com> <20200426165753.GA11046@wind.enjellic.com> <87d07gk24l.fsf@nanos.tec.linutronix.de> <20200508190226.GA31465@wind.enjellic.com> <20200508195635.GR27052@linux.intel.com> <20200514091637.GA25156@wind.enjellic.com> <20200514161559.GA15603@linux.intel.com> <20200514162054.GE9266@zn.tnic>
Date:   Thu, 14 May 2020 21:29:13 +0200
Message-ID: <87pnb6xqly.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Borislav Petkov <bp@alien8.de> writes:

> On Thu, May 14, 2020 at 09:15:59AM -0700, Sean Christopherson wrote:
>> I'm not opposed to adding a kernel param to disable SGX.  At one point
>> there was a proposal to extend clearcpuid to allow disabling multiple
>> feature bits, but it looks like that went the way of the dodo.

clearcpuid is a trainwreck which should have never happened.

>> Note, such a param would disable SGX entirely, e.g. clear the feature bit
>> in /proc/cpuinfo and prevent any in-kernel SGX code from running.
>
> It is a usual practice for big features like SGX to add a
> "nosgx" cmdline param to disable it in case something goes
> south. We do this for all features - see all "no*" switches in
> Documentation/admin-guide/kernel-parameters.txt

Correct.

Thanks,

        tglx
