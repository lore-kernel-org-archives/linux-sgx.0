Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CF85387362;
	Thu,  4 Jun 2026 18:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780597796; cv=none; b=IbpE0P1wREFv0C6SPYgXA+nIRZESStIa5heKX4zdzPmsGpL0HcwhwURpLT9DDOuDyTb6eujKxSHmjbVdcXXMbwbOVfUyVh58VlHEElGUBnZzA4UiT3mPEUvZea1NtL9ivgnAhFXgV98kL9jzVfQlsFRt5CoFCBlWCxCTOuVSAr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780597796; c=relaxed/simple;
	bh=tdCBIKH15YGi5T/akMz88/niI0yIDsK4QHkJGr0NjXw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=i/7rwAZhSxOVK+h2WMuKGn0rbQE3cttQ8mmIGh+GHBtIbp4rS2EJjAAQRAdHgb9BmtBFQDiGYnLvIYoubD8nZZKvlR/Ri7BrMZNh+sk4A7E3L4847IdpAX3Qtq1sJXy3KhtBa4NGVIiAsDzNb65gWwBbaSP/2ilESZVsPFGnQ04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 051ED201CB9;
	Thu,  4 Jun 2026 20:29:48 +0200 (CEST)
Date: Thu, 4 Jun 2026 20:29:46 +0200
From: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
To: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	coconut-svsm@lists.linux.dev, linux-sgx@vger.kernel.org
Cc: Dhaval Giani <dhaval.giani@gmail.com>
Subject: [CfP] Confidential Computing Microconference (LPC 2026)
Message-ID: <aiHCZo2BWj0MaJLQ@8bytes.org>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi everyone,

We are pleased to officially open the Call for Presentations for the 2026
Confidential Computing Microconference at LPC this year. LPC will take place
from October 5th to 7th in Prague.

Our goal is to bring open-source developers and industry experts together for
productive discussions that lead to concrete solutions. We are looking for
interactive discussions, ongoing development topics, and problem-solving
sessions rather than static status updates.

We are looking for proposals covering, but not limited to, the following
developments and challenges:

	* Enhancements to CVM memory backing via `guest_memfd`
	* KVM Support for ARM CCA
	* Privilege separation features in KVM
	* CVM live migration
	* Secure VM Service Module (SVSM) architecture and Linux support
	* Trusted I/O software architecture
	* Solutions for the full CVM (remote) attestation problem
	* Linux as a CVM operating system across hypervisors
	* CVM Performance optimization and benchmarking

If you are working on any of these areas or have another critical Confidential
Computing topic that requires community alignment, please submit your proposal!

LPC microconferences are built around discussion and collaboration. Proposals
should focus on open problems, architectural roadblocks, or design choices that
would benefit from in-person feedback from the community.

* Submit here:		https://lpc.events/event/20/abstracts/
* Submission Deadline:	August 7, 2026

Make sure to select "Confidential Computing MC" as the track! This year the LPC
organization committee will grant pre-registration vouchers to anyone who has
submitted a topic. These are at the usual price ($600) which must be used
before registration opens. If your topic is not accepted you should be eligible
for a refund if your employer doesn’t approve your travel. For more details see

	https://lpc.events/blog/current/index.php/2026/04/06/changes-to-registration-availability-for-2026/

Looking forward to seeing you there,


- Dhaval and Joerg
