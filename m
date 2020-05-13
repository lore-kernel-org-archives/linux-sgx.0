Return-Path: <SRS0=1HHV=63=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A04DC433DF
	for <linux-sgx@archiver.kernel.org>; Wed, 13 May 2020 22:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FA1620693
	for <linux-sgx@archiver.kernel.org>; Wed, 13 May 2020 22:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730643AbgEMWO2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 13 May 2020 18:14:28 -0400
Received: from mga04.intel.com ([192.55.52.120]:54906 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730532AbgEMWO1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 13 May 2020 18:14:27 -0400
IronPort-SDR: vPDP+f/KiFkAlRmVUmJzzoH9cDfbaj/7Qk0bkGHGflX6Vg+rqxEbxW3k+eYv6egJXKT/1TbBv+
 XbfqzVsBJAKA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2020 15:14:27 -0700
IronPort-SDR: GxdBgm6DGszalFODl1dKv7iCkyQpPXtsRxlrg3eHT5cnlqlgajinY7R3MsmipiqAJU8o6TX8yJ
 +fibgZRJ/uVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,389,1583222400"; 
   d="scan'208";a="287185274"
Received: from rthurerx-mobl.ger.corp.intel.com ([10.249.36.107])
  by fmsmga004.fm.intel.com with ESMTP; 13 May 2020 15:14:20 -0700
Message-ID: <0d485f780ac9809229290762931cd591e6f8156a.camel@linux.intel.com>
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Nathaniel McCallum <npmccallum@redhat.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Neil Horman <nhorman@redhat.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, David Rientjes <rientjes@google.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>
Date:   Thu, 14 May 2020 01:14:19 +0300
In-Reply-To: <CAOASepPFe_ucuwe7JW_-+VBQ4=+sHqyGXOdA9kUbcYA_9=v0sA@mail.gmail.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
         <CAOASepPFe_ucuwe7JW_-+VBQ4=+sHqyGXOdA9kUbcYA_9=v0sA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 2020-05-06 at 17:42 -0400, Nathaniel McCallum wrote:
> Tested on Enarx. This requires a patch[0] for v29 support.
> 
> Tested-by: Nathaniel McCallum <npmccallum@redhat.com>

Thank you. Update in my tree.

Sean, I'll fixed that whitespace issue too in my tree.

General question: maybe it would be easiest that I issue a pull request
once everyone feels that the series is ready to be pulled and stop sending
new versions of the series?

/Jarkko

