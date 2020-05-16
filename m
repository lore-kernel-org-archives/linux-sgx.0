Return-Path: <SRS0=rc/c=66=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AEDEC433DF
	for <linux-sgx@archiver.kernel.org>; Sat, 16 May 2020 09:58:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 070842076A
	for <linux-sgx@archiver.kernel.org>; Sat, 16 May 2020 09:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgEPJ6b (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 16 May 2020 05:58:31 -0400
Received: from mga11.intel.com ([192.55.52.93]:36071 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbgEPJ6b (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 16 May 2020 05:58:31 -0400
IronPort-SDR: iPXEH6ZLRvylIXBDZmOSXGvBzqXr5tEpB1cXlrdVakCQjgrFgxNE1yhDSBQY4+6p8lpjkry9cg
 Ow4ZDyePfzxw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2020 02:58:31 -0700
IronPort-SDR: 6jHPUG3ThIOMSn2cKDvFGp+3eTCtSgVNNl6Od8zlni+TI6/ZAjaV2ZEbEAoj0UnG+736LLpoRN
 M7Y4cR8y+t+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,398,1583222400"; 
   d="scan'208";a="281482113"
Received: from dbobocel-mobl1.ger.corp.intel.com ([10.252.55.115])
  by orsmga002.jf.intel.com with ESMTP; 16 May 2020 02:58:21 -0700
Message-ID: <315b5759b04e900a24ed1ec3d51439c49f312c06.camel@linux.intel.com>
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Nathaniel McCallum <npmccallum@redhat.com>,
        "Dr. Greg" <greg@enjellic.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        Neil Horman <nhorman@redhat.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, David Rientjes <rientjes@google.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>
Date:   Sat, 16 May 2020 12:58:20 +0300
In-Reply-To: <CAOASepNdOqsoYvPPf7+0_qU70JBMb9GMONrGX+jdt=SQtT1X8g@mail.gmail.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
         <20200426165753.GA11046@wind.enjellic.com>
         <87d07gk24l.fsf@nanos.tec.linutronix.de>
         <20200508190226.GA31465@wind.enjellic.com>
         <20200508195635.GR27052@linux.intel.com>
         <20200514091637.GA25156@wind.enjellic.com>
         <CAOASepNdOqsoYvPPf7+0_qU70JBMb9GMONrGX+jdt=SQtT1X8g@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 2020-05-15 at 15:54 -0400, Nathaniel McCallum wrote:
> The (Red Hat sponsored) Enarx project will continue building an
> unofficial, unsupported version of the Fedora kernel with the SGX
> patches[0] until such time as the patches are upstream. Once upstream,
> I intend to propose that the feature be enabled in the stock Fedora
> kernel.
> 
> Enarx requires EDMM support as a prerequisite to being production
> ready. Therefore, we are likely to continue building this custom
> Fedora kernel with the latest patches until such point as EDMM support
> lands upstream. This also implies that I have no current plan to
> request an SGX backport to a RHEL kernel until such time as it
> supports our full needs.
> 
> Disclaimer: I do not control RHEL or Fedora kernel features. None of
> the above constitutes a commitment to deliver anything.
> 
> [0]: https://copr.fedorainfracloud.org/coprs/npmccallum/enarx/package/kernel/

SGX is somewhat self-contained feature, i.e. should be easy to backport
for any recent kernel. Only the vDSO is outside of arch/x86/kernel/cpu/sgx.

/Jarkko

