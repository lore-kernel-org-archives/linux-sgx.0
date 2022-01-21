Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A30B2C433F5
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Jan 2022 19:57:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbiAUT5y (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 21 Jan 2022 14:57:54 -0500
Received: from mga06.intel.com ([134.134.136.31]:52453 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230509AbiAUT5y (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 21 Jan 2022 14:57:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642795073; x=1674331073;
  h=to:cc:from:subject:message-id:date:mime-version:
   content-transfer-encoding;
  bh=QsLfnfQWZkOYKdn86Wvp1w0EfnCx2UQs1nZSU1jNlq4=;
  b=T0CUZTI+caL6hcjolJOD7/YbkCL0kW8vVN6fzyL8zM34g3fv1pAgA53L
   B6FNrIpUqdjp2ZOicIRnsSgVLIe/8/5lh0FMVIFdtwviFXL1iR2dPnHOa
   P4C8hyGRs54U+NlcVTtgS3Vh5wgC4ZJHv9KertsM+wdzAjzT9NobwWCnD
   OmXE5Ym2xBfxqUTBg8P3YBTWLmmMfr0YjZtf92wSzeyLPQXfCK1Q0jesp
   vwx/+fU41++vOqNcnrbl6XbXktqfXJRla9YUbXPbOF5nag6q7DReZ3u8V
   9gmG2/fwoHN8GIu5zzq5bj0r3Kvib2Ve9xhPSoNmZpaMRQzwhayvYOXgF
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10234"; a="306451785"
X-IronPort-AV: E=Sophos;i="5.88,306,1635231600"; 
   d="scan'208";a="306451785"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2022 11:57:53 -0800
X-IronPort-AV: E=Sophos;i="5.88,306,1635231600"; 
   d="scan'208";a="478355941"
Received: from kvuppama-mobl.amr.corp.intel.com (HELO [10.209.120.167]) ([10.209.120.167])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2022 11:57:53 -0800
To:     "Sakkinen, Jarkko" <jarkko.sakkinen@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
Cc:     "Accardi, Kristen C" <kristen.c.accardi@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Testing 5.17 bugfix material
Message-ID: <53bf06e8-f523-83db-ed4d-039c34f634cd@intel.com>
Date:   Fri, 21 Jan 2022 11:57:50 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Hi Everyone,

There are a few SGX fixes that have showed up in the last week or so,
mostly around RAS and fixing the backing storage issues.  Could folks
please give this branch a good thrashing?

> https://git.kernel.org/pub/scm/linux/kernel/git/daveh/devel.git/log/?h=x86/sgx

I'm planning to send this bunch up to Linus after 5.17-rc1 comes out.

Kristen, I really dug into the changelogs of your two patches to make it
more clear that they are bugfix and stable@ material.  I'd appreciate
some additional eyeballs there.
