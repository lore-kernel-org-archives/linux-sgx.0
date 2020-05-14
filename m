Return-Path: <SRS0=4/gY=64=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D94C433E0
	for <linux-sgx@archiver.kernel.org>; Thu, 14 May 2020 19:30:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B3F3207C3
	for <linux-sgx@archiver.kernel.org>; Thu, 14 May 2020 19:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgENTav (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 14 May 2020 15:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725965AbgENTav (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 14 May 2020 15:30:51 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2CDC061A0C;
        Thu, 14 May 2020 12:30:50 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jZJZ4-0007W6-Lh; Thu, 14 May 2020 21:30:42 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 283061004CE; Thu, 14 May 2020 21:30:42 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Nathaniel McCallum <npmccallum@redhat.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com,
        "Christopherson\, Sean J" <sean.j.christopherson@intel.com>,
        Neil Horman <nhorman@redhat.com>,
        "Huang\, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com,
        "Svahn\, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, David Rientjes <rientjes@google.com>,
        "Xing\, Cedric" <cedric.xing@intel.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
In-Reply-To: <0d485f780ac9809229290762931cd591e6f8156a.camel@linux.intel.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com> <CAOASepPFe_ucuwe7JW_-+VBQ4=+sHqyGXOdA9kUbcYA_9=v0sA@mail.gmail.com> <0d485f780ac9809229290762931cd591e6f8156a.camel@linux.intel.com>
Date:   Thu, 14 May 2020 21:30:42 +0200
Message-ID: <87mu6axqjh.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> writes:
>
> General question: maybe it would be easiest that I issue a pull request
> once everyone feels that the series is ready to be pulled and stop sending
> new versions of the series?

Might be the easiest for you, but I prefer a final series in email.

Thanks,

        tglx
