Return-Path: <SRS0=5ZAu=65=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 476A6C433E0
	for <linux-sgx@archiver.kernel.org>; Fri, 15 May 2020 00:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22A2320709
	for <linux-sgx@archiver.kernel.org>; Fri, 15 May 2020 00:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgEOAWz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 14 May 2020 20:22:55 -0400
Received: from mga18.intel.com ([134.134.136.126]:18747 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgEOAWz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 14 May 2020 20:22:55 -0400
IronPort-SDR: hrkeZvzs8AuDfsB+Vi3qM/b/cURaPAhnpgCElNVSiyin5lX3emI1fG4RzQ7ZKuAzhLJ91PgBuL
 ftMXDparxILA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 17:22:55 -0700
IronPort-SDR: OZ4ixah5KYXcx6c/A5+OSoQO30BXj+L/WT0S1pQ97QZjRxynR+7g+fXQ8ka5JpY/wppQEfHkWG
 I3uhiHFqwfLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,392,1583222400"; 
   d="scan'208";a="281038937"
Received: from ashadrin-mobl1.ccr.corp.intel.com ([10.249.38.112])
  by orsmga002.jf.intel.com with ESMTP; 14 May 2020 17:22:48 -0700
Message-ID: <3f9c2463e3063552d9a720e1dec90eb316e49751.camel@linux.intel.com>
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Nathaniel McCallum <npmccallum@redhat.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Neil Horman <nhorman@redhat.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, David Rientjes <rientjes@google.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>
Date:   Fri, 15 May 2020 03:22:36 +0300
In-Reply-To: <87mu6axqjh.fsf@nanos.tec.linutronix.de>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
         <CAOASepPFe_ucuwe7JW_-+VBQ4=+sHqyGXOdA9kUbcYA_9=v0sA@mail.gmail.com>
         <0d485f780ac9809229290762931cd591e6f8156a.camel@linux.intel.com>
         <87mu6axqjh.fsf@nanos.tec.linutronix.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2020-05-14 at 21:30 +0200, Thomas Gleixner wrote:
> Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> writes:
> > General question: maybe it would be easiest that I issue a pull request
> > once everyone feels that the series is ready to be pulled and stop sending
> > new versions of the series?
> 
> Might be the easiest for you, but I prefer a final series in email.
> 
> Thanks,
> 
>         tglx

For me both are just as easy or as hard :-)

Just wanted to query the preference.

/Jarkko

