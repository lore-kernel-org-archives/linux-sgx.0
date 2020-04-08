Return-Path: <SRS0=hoRE=5Y=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C56C2D0EA
	for <linux-sgx@archiver.kernel.org>; Wed,  8 Apr 2020 14:56:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10355206F7
	for <linux-sgx@archiver.kernel.org>; Wed,  8 Apr 2020 14:56:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgDHO4h (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 8 Apr 2020 10:56:37 -0400
Received: from mga12.intel.com ([192.55.52.136]:3071 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727612AbgDHO4h (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 8 Apr 2020 10:56:37 -0400
IronPort-SDR: lFvwlLDIZbISapiQrx3ykqopa8RIm0looU28dMWhNZq+WnSuepwQdNQAnMEwzbw2qSZF/aJ7aV
 ZAy8lzs52CJA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2020 07:56:37 -0700
IronPort-SDR: Qe8StWb1WcQVGSc8JG671UAyNY18ZrV537p/oGBGH0VBNkYitnTnHpwPmYStXpFafTD8SHBcui
 edD5IEBTIK/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,358,1580803200"; 
   d="scan'208";a="254820494"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 08 Apr 2020 07:56:37 -0700
Date:   Wed, 8 Apr 2020 07:56:36 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Topi Miettinen <toiwoton@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        ben@decadent.org.uk
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
Message-ID: <20200408145636.GD10686@linux.intel.com>
References: <20200406185530.GE20105@linux.intel.com>
 <F4B63BCD-F554-4BE2-B3AE-4ADB6C2F4285@amacapital.net>
 <20200406212434.GA34134@linux.intel.com>
 <ed382297-1488-1cdc-bd3f-a8a45de6c488@gmail.com>
 <20200407165704.GA14583@linux.intel.com>
 <20200407165900.GB14583@linux.intel.com>
 <20200407180410.GA17916@linux.intel.com>
 <7009f0e2-cdfc-1703-2b73-bb683a89c8d1@gmail.com>
 <20200408134049.GB4097@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408134049.GB4097@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Apr 08, 2020 at 04:40:49PM +0300, Jarkko Sakkinen wrote:
> What starts to be obvious is that we don't do anything in code level
> in SGX particular but instead workaround something around /dev.

Can you summarize the plan going forward?  Thanks!
