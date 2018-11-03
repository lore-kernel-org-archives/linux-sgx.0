Return-Path: <SRS0=zuU4=NO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4666EC65C22
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Nov 2018 01:07:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E82A720833
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Nov 2018 01:07:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="XIhEeeYy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E82A720833
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fortanix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbeKCKQ7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 3 Nov 2018 06:16:59 -0400
Received: from mail-eopbgr810107.outbound.protection.outlook.com ([40.107.81.107]:58797
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728265AbeKCKQ7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 3 Nov 2018 06:16:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScVP+IwPYHaD35g0XBNdDTDlboPIok6UlyB2NAPTQ54=;
 b=XIhEeeYypnKSPhc05SdeCGVOHUJTpBB7G3lNkMyVZMGrrAJeNe56gjAULNrQZjldh+87S64KsPNso/9bsW40WEwTYQ9XjCywaYm08fTMqvvfkTId/aXDH2EzFQwa9T1LM0jCGlye0JpTwZDrBgB7vFkMjk/z31wFl6jEhX9xWBI=
Received: from BL0PR11MB3156.namprd11.prod.outlook.com (10.167.182.202) by
 BL0PR11MB2913.namprd11.prod.outlook.com (20.177.147.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.27; Sat, 3 Nov 2018 01:07:27 +0000
Received: from BL0PR11MB3156.namprd11.prod.outlook.com
 ([fe80::6c63:1386:bfb9:bccf]) by BL0PR11MB3156.namprd11.prod.outlook.com
 ([fe80::6c63:1386:bfb9:bccf%4]) with mapi id 15.20.1294.024; Sat, 3 Nov 2018
 01:07:27 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>
CC:     "dave.hansen@intel.com" <dave.hansen@intel.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
        "haitao.huang@intel.com" <haitao.huang@intel.com>,
        "mark.shanahan@intel.com" <mark.shanahan@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 16/23] x86/sgx: Enumerate and track EPC sections
Thread-Topic: [PATCH v15 16/23] x86/sgx: Enumerate and track EPC sections
Thread-Index: AQHUcwI1BSjYS4H/iESFB0r/BSeZsKU9PR8A
Date:   Sat, 3 Nov 2018 01:07:27 +0000
Message-ID: <79867568-c21f-8a09-d06e-360b1b925dd5@fortanix.com>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
 <20181102231320.29164-17-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20181102231320.29164-17-jarkko.sakkinen@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: YTXPR0101CA0033.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00::46) To BL0PR11MB3156.namprd11.prod.outlook.com
 (2603:10b6:208:2e::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [172.56.38.81]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR11MB2913;6:d90FT72F8tUtbRUJgtbZaEYBCI3sJY5JuQWKC3iKlnOQGyD6UiesWC4iouySwNfYJ/emSJ2bV9YMoyEtD0weF5SsMTwHyZBwl7uIa/31QCrfYpbjGaZCfYqx25RJKwAUChMec9fvjhWCC8p2zRYEIyISdFxt/EYob0/jp3trUspNnlM4mDd1bcs0MQsxHFy6zFah9ucM1goZuQzfpACFrS1nLH86zsvH4KwGspR8PPvMbcrGgGVHiI1np7Ge8VWbGOmixgH+P773S+FKMEqPRAyFrjMikLlBGweGLo5AoPi78tUZSU5jRxd9emuLN1XBbg7ihe6Ovc13bVYAeJKW0g3AyNewzAQoUs6f+GRFeD4E/O13LUwcqyMZyK4J/2sUaAjWvfSWhLm/McDkSmr3r+t27lhcxppwjGQtVl/woo4u8IytD5fqGZu4CixLQ87Cs2Xh9n/zNBtUM+Rht0gbaw==;5:XbNdF4KJjHeHKn4QJ6JkqCTQJqSnJPEKVzP+cxwUcV9W0a5js9V1GX8sbXO8l06M55xsGNR5uAIIPSMryyi6K7Gx7/3btFS0M7Licwhw33cXS7MfcHUUlG1blXv8R2CHYqPs1fSsFO5sHBlS5Er48KQTyejctqIovhm7v7FRVC0=;7:uXQ/jMi4WXb/YSOkuf8il6ljql4Zjyn5zOrutkNi4+Krrs1EHbOFe9z1a0AMncLCPXmiMn+KKGaqtciAoeUXlcfbDrw9di0Unwmz/vtAdoEoD8ARt8nOdsemZOBdsMMaCF3Rs1VnJngjxjtweA6HzA==
x-ms-office365-filtering-correlation-id: fe5bd2ec-6a90-4569-1cf5-08d64128b85b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(7021145)(8989299)(5600074)(711020)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(2017052603328)(7153060)(49563074)(7193020);SRVR:BL0PR11MB2913;
x-ms-traffictypediagnostic: BL0PR11MB2913:
x-microsoft-antispam-prvs: <BL0PR11MB2913E7599E5D50A964458B26AAC80@BL0PR11MB2913.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(102415395)(6040522)(2401047)(5005006)(8121501046)(93006095)(93001095)(10201501046)(3002001)(3231382)(944501410)(4983020)(52105095)(148016)(149066)(150057)(6041310)(2016111802025)(20161123558120)(20161123564045)(20161123560045)(20161123562045)(6043046)(201708071742011)(7699051)(76991095);SRVR:BL0PR11MB2913;BCL:0;PCL:0;RULEID:;SRVR:BL0PR11MB2913;
x-forefront-prvs: 08457955C4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39830400003)(396003)(376002)(136003)(366004)(189003)(199004)(2900100001)(2501003)(6246003)(31696002)(99936001)(6512007)(99286004)(256004)(26005)(5660300001)(2906002)(36756003)(316002)(14444005)(97736004)(54906003)(3846002)(6116002)(110136005)(68736007)(186003)(7416002)(8936002)(2201001)(81166006)(76176011)(71200400001)(446003)(386003)(53546011)(6506007)(2616005)(81156014)(86362001)(71190400001)(11346002)(486006)(102836004)(229853002)(52116002)(8676002)(476003)(25786009)(106356001)(305945005)(7736002)(31686004)(508600001)(105586002)(53936002)(4326008)(66066001)(6436002)(14454004)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL0PR11MB2913;H:BL0PR11MB3156.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: yw7dPsyyLfBiI/tztIwziVrxc4RWDcrxLqIrhuPeLxRvOXFpXzLc9fopnhgcvCknn5qmLaf24kI+FWGzxtPYiSkknsnV2TZlVoSZG7e1QlO/iZVnIhKVXXbnYTsbGqF5Ix+dNexDN12ZqBq2sygdDtov80anftEjiBY27tIDnBoUER8xzCKguRJ02c8s/b6IMxh1vDJ7mHSlTzJF778w0F/i7wPIi3YiLoabfZcCdl57O5way/XiGDvtOPlo1UwIB/sLPT65elgBQIRb6sgwKLd4aaViql3ABc+1cW4+CG6Owg0N59h5I/We3txUDa37jijw2xkHp5gKlWRaABE7talsyq/mn3/26PPacPON+7Y=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms010703040107000800010004"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe5bd2ec-6a90-4569-1cf5-08d64128b85b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2018 01:07:27.1002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB2913
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181103010727.IWlPptT3DdqIpMbb_jNBNqKlYuj7x5YTzWvnrmGhFD4@z>

--------------ms010703040107000800010004
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2018-11-02 16:11, Jarkko Sakkinen wrote:
> diff --git a/arch/x86/kernel/cpu/intel_sgx.c b/arch/x86/kernel/cpu/inte=
l_sgx.c
> new file mode 100644
> index 000000000000..b86aa4111592
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/intel_sgx.c
>=20
> ...
>=20
> +static __init int sgx_page_cache_init(void)
> +{
> +	u32 eax, ebx, ecx, edx, type;
> +	u64 pa, size;
> +	int ret;
> +	int i;
> +
> +	BUILD_BUG_ON(SGX_MAX_EPC_SECTIONS > (SGX_EPC_SECTION_MASK + 1));
> +
> +	for (i =3D 0; i < SGX_MAX_EPC_SECTIONS; i++) {

Perhaps print a warning if there are more than SGX_MAX_EPC_SECTIONS=20
sections reported by CPUID.

> +		cpuid_count(SGX_CPUID, i + SGX_CPUID_FIRST_VARIABLE_SUB_LEAF,
> +			    &eax, &ebx, &ecx, &edx);
> +
> +		type =3D eax & SGX_CPUID_SUB_LEAF_TYPE_MASK;
> +		if (type =3D=3D SGX_CPUID_SUB_LEAF_INVALID)
> +			break;
> +		if (type !=3D SGX_CPUID_SUB_LEAF_EPC_SECTION) {
> +			pr_err_once("sgx: Unknown sub-leaf type: %u\n", type);
> +			continue;
> +		}
> +
> +		pa =3D sgx_calc_section_metric(eax, ebx);
> +		size =3D sgx_calc_section_metric(ecx, edx);
> +		pr_info("sgx: EPC section 0x%llx-0x%llx\n", pa, pa + size - 1);
> +
> +		ret =3D sgx_init_epc_section(pa, size, i, &sgx_epc_sections[i]);
> +		if (ret) {
> +			sgx_page_cache_teardown();
> +			return ret;
> +		}
> +
> +		sgx_nr_epc_sections++;
> +	}
> +
> +	if (!sgx_nr_epc_sections) {
> +		pr_err("sgx: There are zero EPC sections.\n");
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}

--
Jethro Beekman | Fortanix


--------------ms010703040107000800010004
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
Cx8wggUxMIIEGaADAgECAhBdZC9mIseKJlmxx1xn+g00MA0GCSqGSIb3DQEBCwUAMIGXMQsw
CQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxm
b3JkMRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBD
bGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQTAeFw0xODA5MTUwMDAw
MDBaFw0xOTA5MTUyMzU5NTlaMCQxIjAgBgkqhkiG9w0BCQEWE2pldGhyb0Bmb3J0YW5peC5j
b20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDRQDOQsroKjy2xAQCXLyqryJt4
Xwj8hcweJCzOnjILKHIoWlOQ0b9yIbFLIWBRt/9zdxlE5ZabDVHnkIyhcVgtU/BA73e78Wx2
LOObdg0wfs9U2CVRYhz2EPHFjGvkYKihItt69ye91hj1w7RKCrYC8KZGSZ/+sbkJzQdXVy32
lxmiNEt17GNRebpkJCaFnznd6C2a8tBAS2Fa/UNyFdEs4eoRoYSKswclRhbe81aVhqY2hjcd
O6puyyaYp5hkmau2UPih6OpRSOhbe6Tuebceg1yvumoVX3OZtGPS1VdQ+p0bxB0RE6gNs140
ZKUhrvAJDETuGaaQD4A2/6ksLunjAgMBAAGjggHpMIIB5TAfBgNVHSMEGDAWgBSCr2yM+MX+
lmF86B89K3FIXsSLwDAdBgNVHQ4EFgQUsFUcmGtaJBU7/52LyTYHC/M+LscwDgYDVR0PAQH/
BAQDAgWgMAwGA1UdEwEB/wQCMAAwIAYDVR0lBBkwFwYIKwYBBQUHAwQGCysGAQQBsjEBAwUC
MBEGCWCGSAGG+EIBAQQEAwIFIDBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEBATArMCkGCCsG
AQUFBwIBFh1odHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+gTaBL
hklodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlv
bmFuZFNlY3VyZUVtYWlsQ0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKGSWh0
dHA6Ly9jcnQuY29tb2RvY2EuY29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5k
U2VjdXJlRW1haWxDQS5jcnQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNv
bTAeBgNVHREEFzAVgRNqZXRocm9AZm9ydGFuaXguY29tMA0GCSqGSIb3DQEBCwUAA4IBAQB6
v3tFEUSGv9+yY4wUjvcMyz3126nJrX5LkfEvrnCEpEiImECuoYvxOYNLYYynell7BQGtTaZg
shMfDvwpy2isoi3w1AWAfbn6npnSKLzu0BMRvcCPWY8VPmePPizTqXoPkLwgTJfSaWkxMP1u
rfL9S5NeRdkjwjHklX5IWuwwDu1hsKVZrxSSY2unCtvq67UHWz+z6rG1JQrP2YDfb98xun3y
eLBNe/LFBNnGISbkT5q6D+e5c0bgzoH9nH4bsw3t8aDqJTfT3BqQdWr4pF05ODzzeOmEqeYE
qGlD9hIL2AbmTZLjunAnARr6Fv7Sfqt23ptsGkmoZ9ZQNjT3TlwvMIIF5jCCA86gAwIBAgIQ
apvhODv/K2ufAdXZuKdSVjANBgkqhkiG9w0BAQwFADCBhTELMAkGA1UEBhMCR0IxGzAZBgNV
BAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09N
T0RPIENBIExpbWl0ZWQxKzApBgNVBAMTIkNPTU9ETyBSU0EgQ2VydGlmaWNhdGlvbiBBdXRo
b3JpdHkwHhcNMTMwMTEwMDAwMDAwWhcNMjgwMTA5MjM1OTU5WjCBlzELMAkGA1UEBhMCR0Ix
GzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UE
ChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
ggEKAoIBAQC+s55XrCh2dUAWxzgDmNPGGHYhUPMleQtMtaDRfTpYPpynMS6n9jR22YRq2tA9
NEjk6vW7rN/5sYFLIP1of3l0NKZ6fLWfF2VgJ5cijKYy/qlAckY1wgOkUMgzKlWlVJGyK+Ul
NEQ1/5ErCsHq9x9aU/x1KwTdF/LCrT03Rl/FwFrf1XTCwa2QZYL55AqLPikFlgqOtzk06kb2
qvGlnHJvijjI03BOrNpo+kZGpcHsgyO1/u1OZTaOo8wvEU17VVeP1cHWse9tGKTDyUGg2hJZ
jrqck39UIm/nKbpDSZ0JsMoIw/JtOOg0JC56VzQgBo7ictReTQE5LFLG3yQK+xS1AgMBAAGj
ggE8MIIBODAfBgNVHSMEGDAWgBS7r34CPfqm8TyEjq3uOJjs2TIy1DAdBgNVHQ4EFgQUgq9s
jPjF/pZhfOgfPStxSF7Ei8AwDgYDVR0PAQH/BAQDAgGGMBIGA1UdEwEB/wQIMAYBAf8CAQAw
EQYDVR0gBAowCDAGBgRVHSAAMEwGA1UdHwRFMEMwQaA/oD2GO2h0dHA6Ly9jcmwuY29tb2Rv
Y2EuY29tL0NPTU9ET1JTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHEGCCsGAQUFBwEB
BGUwYzA7BggrBgEFBQcwAoYvaHR0cDovL2NydC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQWRk
VHJ1c3RDQS5jcnQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTANBgkq
hkiG9w0BAQwFAAOCAgEAeFyygSg0TzzuX1bOn5dW7I+iaxf28/ZJCAbU2C81zd9A/tNx4+js
QgwRGiHjZrAYayZrrm78hOx7aEpkfNPQIHGG6Fvq3EzWf/Lvx7/hk6zSPwIal9v5IkDcZoFD
7f3iT7PdkHJY9B51csvU50rxpEg1OyOT8fk2zvvPBuM4qQNqbGWlnhMpIMwpWZT89RY0wpJO
+2V6eXEGGHsROs3njeP9DqqqAJaBa4wBeKOdGCWn1/Jp2oY6dyNmNppI4ZNMUH4Tam85S1j6
E95u4+1Nuru84OrMIzqvISE2HN/56ebTOWlcrurffade2022O/tUU1gb4jfWCcyvB8czm12F
gX/y/lRjmDbEA08QJNB2729Y+io1IYO3ztveBdvUCIYZojTq/OCR6MvnzS6X72HP0PRLRTiO
SEmIDsS5N5w/8IW1Hva5hEFy6fDAfd9yI+O+IMMAj1KcL/Zo9jzJ16HO5m60ttl1Enk8MQkz
/W3JlHaeI5iKFn4UJu1/cP2YHXYPiWf2JyBzsLBrGk1II+3yL8aorYew6CQvdVifC3HtwlSa
m9V1niiCfOBe2C12TdKGu05LWIA3ZkFcWJGaNXOZ6Ggyh/TqvXG5v7zmEVDNXFnHn9tFpMpO
UvxhcsjycBtH0dZ0WrNw6gH+HF8TIhCnH3+zzWuDN0Rk6h9KVkfKehIxggQ1MIIEMQIBATCB
rDCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UE
BxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9E
TyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yi
x4omWbHHXGf6DTQwDQYJYIZIAWUDBAIBBQCgggJZMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0B
BwEwHAYJKoZIhvcNAQkFMQ8XDTE4MTEwMzAxMDcyMFowLwYJKoZIhvcNAQkEMSIEIBcw6GtW
A+kFz6AeXOsifTeXfGTfUPKEoY7bxNirwK7NMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQBgrZ94hQD+4wlfv32rtPyobUxtR4r5yVhHtizcS0n9s/wCRurmAlEKKQyvKjA7R6O0cOcC
EYAZ8h/iFCDQti1Zq17L0kQVRUyOCNTvdBTcnGYDdQh8SkDl/dAgwUQrepv+SiFbbJzNLo3t
GoesB2afJGR1lsGNPwbdOe/vaNF1qvQPCiLMP5WbqBnjJUpWDFHF51hel6XkfUo2B03S2IsS
D5RL3zN5LqzBZxYZbC1L0Evtkwk0rDh9MS3h1kIKpr+raiXUqQTh2usSDNbH3KAy/r40Eyar
4PP3l/zUWV4o58ZuVgDxFIrKpYRyZAbnngkuBUMdezhBk3dNF73nM2ANAAAAAAAA

--------------ms010703040107000800010004--
