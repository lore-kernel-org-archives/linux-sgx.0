Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6013C433F5
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Mar 2022 19:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236385AbiCITPb (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Mar 2022 14:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237329AbiCITPa (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 9 Mar 2022 14:15:30 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9119C10E54B
        for <linux-sgx@vger.kernel.org>; Wed,  9 Mar 2022 11:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646853270; x=1678389270;
  h=message-id:date:mime-version:to:references:from:subject:
   in-reply-to:content-transfer-encoding;
  bh=EzRCrr2bwhleO/rLeuymuiQf6/thig1/f27V9IEmde8=;
  b=J/vuCSzgskVqvU5WIN/reizX5RImKYS1uYMibfoZGP1bHrXGh07WmqJp
   G9Wow2WhwFEXhOPNOI8FDLBzyImyXgZio0hU44F+lqyPMEwllBRRtaT9f
   XZ1UTlwQOkza6i2PRxvgfut52x+da+0lp7W24ITq6eOKqzry30VS5zShV
   AKEvl/HJKpvy6ahWU2F0jTR35wbTUJxhgYsJyzlKCMddWzBSeZo3wAsXU
   0yJHA6qXRdqRNQrCx1kr0ZQJ54/94A6I8HtucE7pPjMoB4elIc9AgkLXc
   lhat6L/OwVy6C6Q6GfHEVFVW80py6XMPTMycu5DGDvbcymjAq8GdNJbon
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="318290960"
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="318290960"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 11:14:30 -0800
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="642268444"
Received: from sli6-mobl.amr.corp.intel.com (HELO [10.209.104.236]) ([10.209.104.236])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 11:14:29 -0800
Message-ID: <1742be9e-c18e-28c9-75c8-144bf1f6a311@intel.com>
Date:   Wed, 9 Mar 2022 11:14:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        x86@kernel.org
References: <20220309104050.18207-1-cathy.zhang@intel.com>
 <87v8wnhrvg.ffs@tglx>
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC PATCH 00/11] Support microcode updates affecting SGX
In-Reply-To: <87v8wnhrvg.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 3/9/22 11:01, Thomas Gleixner wrote:
>> This series implements the infrastructure needed to track and tear
>> down bare-metal enclaves and then run EUPDATESVN. This is expected
>> to be triggered by administrators via sysfs at some convenient time
>> after a microcode update, probably by the microcode update tooling
>> itself.
> Tear down after a microcode update? This does not make any sense at all,
> really. If the enclaves become inconsistent due to the microcode update

I don't think there's anything that makes the enclaves inconsistent from
the microcode update itself.

Let's imagine an extreme (thankfully imaginary) case: SGX has been
totally broken by some attack.  All running enclaves might have been
compromised.  A magical microcode update comes and saves the day and
mitigates the attack.

From the hardware perspective, at the time of the microcode update, the
(presumably compromised) enclaves *can* still run.  Nothing changes for
them.  The only thing they can't do is attest to the shiny new microcode.

Are you saying that the kernel should consider the enclaves inconsistent
at the time of the microcode update?  Or, were you thinking that the
microcode update process itself would make them inconsistent?
