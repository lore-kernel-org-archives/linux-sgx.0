Return-Path: <SRS0=mkZ9=OE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4628C43441
	for <linux-sgx@archiver.kernel.org>; Sun, 25 Nov 2018 23:52:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 790F920865
	for <linux-sgx@archiver.kernel.org>; Sun, 25 Nov 2018 23:52:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 790F920865
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbeKZKoe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 26 Nov 2018 05:44:34 -0500
Received: from mga05.intel.com ([192.55.52.43]:4692 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726027AbeKZKoe (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 26 Nov 2018 05:44:34 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Nov 2018 15:52:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,279,1539673200"; 
   d="scan'208";a="98941677"
Received: from msymes-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.254.170])
  by FMSMGA003.fm.intel.com with ESMTP; 25 Nov 2018 15:52:00 -0800
Date:   Sun, 25 Nov 2018 15:51:58 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Dr. Greg" <greg@enjellic.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>
Cc:     X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        nhorman@redhat.com, npmccallum@redhat.com,
        "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com,
        haitao.huang@linux.intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, mark.shanahan@intel.com,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181125235109.GA3928@linux.intel.com>
References: <CALCETrXctxfED1Dr-MuZxFnh5gzTyRL06hRJ_fQnNA8p2S4xEQ@mail.gmail.com>
 <20181119161917.GF13298@linux.intel.com>
 <CALCETrX+A4XaEMq3fJqmHUeeDHr_BdWh-Wk3ikXfY=L77BbaGA@mail.gmail.com>
 <20181120120442.GA22172@linux.intel.com>
 <20181122111253.GA31150@wind.enjellic.com>
 <CALCETrWJr-C6yK8NBCp=NbapwHOaBFphiDU9VKEtQ0NMRrdC2g@mail.gmail.com>
 <20181124172114.GB32210@linux.intel.com>
 <20181125145329.GA5777@linux.intel.com>
 <0669C300-02CB-4EA6-BF88-5C4B4DDAD4C7@amacapital.net>
 <20181125185524.GA23224@wind.enjellic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181125185524.GA23224@wind.enjellic.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Nov 25, 2018 at 12:55:24PM -0600, Dr. Greg wrote:
> Good morning to everyone, I hope the weekend continues to proceed
> well.

Thank you, wish the same. Surviving from jetlag after flying from
Finland to Portland yesterday..

Greg, Andy, I'll check your remarks with thought after I'm done with v18
i.e. have less things to multitask with. Is that OK for you? Probably
v18 won't be the last the version anyway.

/Jarkko
