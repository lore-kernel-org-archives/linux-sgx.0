Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C10BDC433EF
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jul 2022 01:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbiGTBmV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 19 Jul 2022 21:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241231AbiGTBmG (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 19 Jul 2022 21:42:06 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814BCC0C;
        Tue, 19 Jul 2022 18:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658281132; x=1689817132;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=c2bvKt7+H9cgbwVo61T9KmcL3V0k2Kq7e6nzPbdgV7g=;
  b=INWVmjBZLBZmzy+oyvfa1AXLqO5S8LWv8e1w35mSjxJnM/sS3iUSuQdB
   9fvcmVVabR0X81AiOoOwFEkOY4cN0cVbLWXDPxi4IlEh5p3/nMMYnawg5
   WCMuG84EwzwjZRPV2nrDv7J9WebnMOCrlFO7ZyhehPo5VrOk1gEmDoTY+
   ZoAkyVwEqL5Lmta0EfQobqlByxTS2+GKPcvtR6TI90jAjIa+ptRg5Dhmt
   MgKKiNJGhxQfXGHIVv7/eKHqANjbNkvu9ISgRJo7GIf3Zri1GfjgQoOEg
   nmqdAspZ9rMLyS6tpK/qc7/vjiYIhmUHpMsjQa4PDx6skyqdZ4LjR1ICw
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10413"; a="284214652"
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="284214652"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2022 18:38:52 -0700
X-IronPort-AV: E=Sophos;i="5.92,285,1650956400"; 
   d="scan'208";a="687336086"
Received: from hhuan26-mobl1.amr.corp.intel.com (HELO hhuan26-mobl1.mshome.net) ([10.212.16.56])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-SHA; 19 Jul 2022 18:38:51 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     linux-kernel@vger.kernel.org,
        "Dave Hansen" <dave.hansen@linux.intel.com>,
        "Dave Hansen" <dave.hansen@intel.com>
Cc:     "Jarkko Sakkinen" <jarkko@kernel.org>,
        "Andy Lutomirski" <luto@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Allow enclaves to use Asynchrounous Exit
 Notification
References: <20220705183648.3739111-1-dave.hansen@linux.intel.com>
 <op.1pasmtstwjvjmi@hhuan26-mobl1.mshome.net>
 <197bba3c-acd2-eb13-4f27-7a5e914ed2e4@intel.com>
Date:   Tue, 19 Jul 2022 20:38:47 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.1pkz6xx8wjvjmi@hhuan26-mobl1.mshome.net>
In-Reply-To: <197bba3c-acd2-eb13-4f27-7a5e914ed2e4@intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, 19 Jul 2022 12:54:41 -0500, Dave Hansen <dave.hansen@intel.com>  
wrote:

> Oh, and, btw...  I don't have any hardware that can actually test this
> patch.  It can't be applied until I have an actual tested-by from
> someone with the hardware.

I can ask someone in our team to test and report back results with  
Tested-by when you post updated patch.
Thanks
Haitao
