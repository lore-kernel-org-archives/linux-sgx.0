Return-Path: <SRS0=PPLm=5W=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FC45C2BA17
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 18:48:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE179206B8
	for <linux-sgx@archiver.kernel.org>; Mon,  6 Apr 2020 18:48:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgDFSsD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 6 Apr 2020 14:48:03 -0400
Received: from mga03.intel.com ([134.134.136.65]:40195 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbgDFSsD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 6 Apr 2020 14:48:03 -0400
IronPort-SDR: XcVHeZQ+yeIJtDZzkqPX+hZNxpPZJZMZ4xyzq+H2ssbpAK1FKH5oBYlmb3a1+2Y/78cQJDVFn2
 5DKmyY6XEhiw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2020 11:48:03 -0700
IronPort-SDR: g/iPW3Mh3sZNk+twneJSLYXI4f82G0F3s34WTP5XF3+tEsA8IyqFZSU9MC/cY55hsumMsnCAIr
 JckZNADOEPTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,352,1580803200"; 
   d="scan'208";a="241862022"
Received: from yweiss1-mobl.ger.corp.intel.com (HELO localhost) ([10.252.49.159])
  by fmsmga007.fm.intel.com with ESMTP; 06 Apr 2020 11:48:00 -0700
Date:   Mon, 6 Apr 2020 21:47:59 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Topi Miettinen <toiwoton@gmail.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andy Lutomirski <luto@kernel.org>, casey.schaufler@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-sgx@vger.kernel.org, "Svahn, Kai" <kai.svahn@intel.com>,
        "Schlobohm, Bruce" <bruce.schlobohm@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        ben@decadent.org.uk
Subject: Re: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
Message-ID: <20200406184759.GD20105@linux.intel.com>
References: <20200403220848.GA7588@linux.intel.com>
 <F117745A-E01B-499E-B9E4-201C1C08258D@amacapital.net>
 <454e7252-8827-510d-65f0-f2ca60208e27@fortanix.com>
 <ea7471ff-146a-73af-903d-34552614b302@gmail.com>
 <e55d56bd-7960-d89a-712e-49daadccb88e@fortanix.com>
 <dd2529f7-6079-e1ef-130d-648cc6e0b9b6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd2529f7-6079-e1ef-130d-648cc6e0b9b6@gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Apr 06, 2020 at 02:01:38PM +0300, Topi Miettinen wrote:
> On 6.4.2020 9.42, Jethro Beekman wrote:
> > On 2020-04-04 09:27, Topi Miettinen wrote> Then initramfs should make a similar exception as with v86d and grant exec to /dev.
> > 
> > I'm not sure this is a reasonable approach. Expect most devices with an Intel processor will have the SGX device going forward. Then, no one is using noexec, so why have this logic at all?
> 
> Intel does not control the whole market yet, does AMD also offer SGX or
> similar? Will SGX be also available for consumer devices? Are distros going
> to enable SGX, will it benefit their users somehow?

It has a strong user base, yes. That's the whole reason for upstreaming it
(like always). It has been available on all CPUs since Skylake.

/Jarkko
