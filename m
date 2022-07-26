Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBEEEC00140
	for <linux-sgx@archiver.kernel.org>; Tue, 26 Jul 2022 15:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbiGZPgi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 26 Jul 2022 11:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiGZPgh (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 26 Jul 2022 11:36:37 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C2ABE38;
        Tue, 26 Jul 2022 08:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658849797; x=1690385797;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Xu3piJu0y2azRJqj+FwPzBL1A84NeXre+q3T4RAy0ZY=;
  b=fCCjofHmAkiEiq/4KnBgdC9wBl9KabBy6lsOV2d2/01sfpV4UGIthfLB
   FKYkK8tm4EscpMm42UTKmfARFEDJZpOK0bzR2c/eSYHkzvbU6Bb4z4Uus
   a722nstdZvrphpDfzmSqNOH+/I+XvktOxTkd0ywJDCnCmSFrr0OMLEarV
   wYoWNacvQO9ji8pNuVjAkoER+8r/PeeHCJV83yhraRHPfHytxGCNqIGMO
   S03/BjoznbwnYY3b1JYmbxpL43UiGzeSuz1ppSwc4uDMkEzwrHiezXR74
   FheZ7P4uwRDH0boQVsSPkaEktEhaUPkHxqqexghBGwXZKF8Q51RTe5WMd
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="286740853"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="286740853"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 08:36:37 -0700
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="658738803"
Received: from mcrowelx-mobl.amr.corp.intel.com (HELO [10.255.229.9]) ([10.255.229.9])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 08:36:36 -0700
Message-ID: <2950d520-c49e-e4d9-90ee-26fe1ec4fb02@intel.com>
Date:   Tue, 26 Jul 2022 08:36:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] [v2] x86/sgx: Allow enclaves to use Asynchrounous Exit
 Notification
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, dave@sr71.net
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Haitao Huang <haitao.huang@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220720191347.1343986-1-dave.hansen@linux.intel.com>
 <ab467244dd03b5f94bafe9068b1c02790033c18c.camel@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <ab467244dd03b5f94bafe9068b1c02790033c18c.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 7/22/22 06:26, Kai Huang wrote:
> Did a quick look at the spec.  It appears ENCLU[EDECCSSA] should be used
> together with AEX-notify.  So besides advertising the new
> SGX_ATTR_ASYNC_EXIT_NOTIFY bit to the KVM guest, I think we should also
> advertise the ENCLU[EDECCSSA] support in guest's CPUID, like below (untested)?

Kai, would you care to send a new version of this with a proper SoB and
changelog integrating what you've learned since posting it?  It can be
merged along with AEX notify itself.
