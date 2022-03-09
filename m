Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCC7BC433EF
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Mar 2022 20:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbiCIUeI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Mar 2022 15:34:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232389AbiCIUeH (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 9 Mar 2022 15:34:07 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE3227142
        for <linux-sgx@vger.kernel.org>; Wed,  9 Mar 2022 12:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646857987; x=1678393987;
  h=message-id:date:mime-version:to:references:from:subject:
   in-reply-to:content-transfer-encoding;
  bh=+CTQ8txnmQsOK/C0UP73kjy/0SeYIW0jlZG1yMXyiPc=;
  b=f/0oT3MoKJA/WCb85CwGgAHeCoySu36DxyrL3pTztQ1bIPgBgikAxzie
   +g45Gi8162flmJN8WVptwJVIgwnf/t2RQTWAbrgZYsGhHJcW8Hl7Q4+9Q
   I8gnmR/0Mk7Mk2QAgmrs53vZ/wBANKJzubej8V2PD9nrY6zOvhYMsMwD5
   8n4yZxHlnGZVMd7x0hH4ao91WlvqxYUowCXyZFooOfQ+EkP6R6VvoIJ+C
   hiaA+Vgx3ar8dZjGt+vRFb2XFEanTCPk035kQYLmsg17klkU059YwlG/9
   nu94wQNKWvvbb6DPMzZisRcmySwFJ5Tp9JHEIpbmusMT+thRUYVmp1LyL
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="237252997"
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="237252997"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 12:32:47 -0800
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="642292387"
Received: from sli6-mobl.amr.corp.intel.com (HELO [10.209.104.236]) ([10.209.104.236])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 12:32:47 -0800
Message-ID: <78b2e9f9-3be0-8670-a827-0a8fe7bf9ba6@intel.com>
Date:   Wed, 9 Mar 2022 12:32:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        x86@kernel.org, "Raj, Ashok" <ashok.raj@intel.com>
References: <20220309104050.18207-1-cathy.zhang@intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC PATCH 00/11] Support microcode updates affecting SGX
In-Reply-To: <20220309104050.18207-1-cathy.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 3/9/22 02:40, Cathy Zhang wrote:
> This series implements the infrastructure needed to track and tear
> down bare-metal enclaves and then run EUPDATESVN. This is expected
> to be triggered by administrators via sysfs at some convenient time
> after a microcode update, probably by the microcode update tooling
> itself.

Cathy, if it isn't abundantly clear by now, everyone seems to hate this
part of the implementation.

Let's just make this just do EUPDATESVN as a part of the microcode
update process.  No new ABI.  No trying to preserve enclaves.  Kill them
early, kill them all, and be done with it.

If we merge that and we have end users chasing us with torches and
pitchforks because their precious enclaves were torn down, we'll think
about doing something different.
